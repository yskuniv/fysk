# frozen_string_literal: true

require_relative "error"
require_relative "value"

module Fysk
  module Interpreter
    class Expression
      def eval(binding)
        raise NotImplementedError
      end

      private

      def get_variable_with_binding(binding, ident)
        variable = binding[ident]
        raise ExpressionEvaluationError, "identifier '#{ident}' is not defined in this scope" unless variable

        variable
      end
    end

    # rubocop:disable Lint/MissingSuper

    class LambdaExpression < Expression
      class << self
        def curry(argument_ident_list, definition_set, expression_list)
          first_argument_ident, *rest_argument_ident_list = argument_ident_list

          case
          when first_argument_ident.nil? || rest_argument_ident_list.empty?
            LambdaExpression.new(first_argument_ident, definition_set, expression_list)
          else
            child_lambda_expression = curry(rest_argument_ident_list, definition_set, expression_list)
            LambdaExpression.new(first_argument_ident, {}, [child_lambda_expression])
          end
        end
      end

      def initialize(argument_ident, definition_set, expression_list)
        @argument_ident = argument_ident
        @definition_set = definition_set
        @expression_list = expression_list
      end

      def eval(binding)
        Function.new(@argument_ident, @definition_set, @expression_list, binding)
      end
    end

    class UnaryExpression < Expression
      def initialize(const: nil, ident: nil, array_expression_list: nil)
        case
        when const
          @const = const
        when ident
          @ident = ident
        when array_expression_list
          @array_expression_list = array_expression_list
        end
      end

      def eval(binding)
        case
        when @const
          @const
        when @ident
          variable = get_variable_with_binding(binding, @ident)
          variable.eval
        when @array_expression_list
          Array.new(@array_expression_list.map { |expression| expression.eval(binding) })
        end
      end
    end

    class BinaryExpression < Expression
      def initialize(left_operand_unary_expression: nil, left_operand_function_application: nil, right_operand_expression: nil, operator: nil)
        @left_operand_expression = left_operand_unary_expression || left_operand_function_application
        @right_operand_expression = right_operand_expression
        @operator = operator
      end

      def eval(binding)
        left_operand_value = @left_operand_expression.eval(binding)
        right_operand_value = @right_operand_expression.eval(binding)
        Constant.new(@operator.calc(left_operand_value.eval, right_operand_value.eval))
      end
    end

    class Binding < Expression
      def initialize(ident, expression)
        @ident = ident
        @expression = expression
      end

      def eval(binding)
        variable = get_variable_with_binding(binding, @ident)
        value = expression.eval(binding)
        variable.bind(value)
      end
    end

    class FunctionApplication < Expression
      def initialize(ident: nil, lambda_expression: nil, parameter_expression_list: [])
        case
        when ident
          @ident = ident
        when lambda_expression
          @lambda_expression = lambda_expression
        end

        @parameter_expression_list = parameter_expression_list
      end

      def eval(binding)
        function = case
                   when @ident
                     get_variable_with_binding(binding, @ident)
                   when @lambda_expression
                     @lambda_expression.eval(binding)
                   end
        argument_values = @parameter_expression_list.map { |expression| expression.eval(binding) }
        function.call(argument_values)
      end
    end

    # rubocop:enable Lint/MissingSuper
  end
end
