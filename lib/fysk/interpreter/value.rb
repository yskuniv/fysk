# frozen_string_literal: true

require_relative "variable"

module Fysk
  module Interpreter
    class Value
      def eval
        raise NotImplementedError
      end
    end

    # rubocop:disable Lint/MissingSuper

    class Function < Value
      def initialize(argument_ident, definition_set, expression_list, binding)
        @argument_ident = argument_ident
        @expression_list = expression_list

        @inner_binding = {}

        # generate variables for identifiers in definition list and register then into inner binding
        definition_set.each do |ident, value|
          @inner_binding[ident] = Variable.new(value)
        end

        # inherit outer binding into inner binding
        binding.each do |ident, variable|
          @inner_binding[ident] = variable
        end
      end

      def eval
        self
      end

      def call(argument_value = nil)
        if argument_value
          raise FunctionCallError, "argument count mismatch detected" unless @argument_ident

          # generate variable for argument identifier and register it into inner binding
          @inner_binding[@argument_ident] = Variable.new(argument_value)
        end

        # eval all expressions in expression list
        @expression_list.reduce do |_, expression|
          expression.eval(@inner_binding)
        end
      end
    end

    class Array < Value
      def initialize(values)
        @array = values.map { |v| Variable.new(v) }
      end

      def eval
        @array.map(&:eval)
      end

      def [](index)
        @array[index].eval
      end

      def []=(index, value)
        @array[index].bind(value)
      end
    end

    class Constant < Value
      def initialize(constant)
        @constant = constant
      end

      def eval
        @constant
      end
    end

    # rubocop:enable Lint/MissingSuper
  end
end
