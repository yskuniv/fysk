# frozen_string_literal: true

module Fysk
  module Interpreter
    class Error < StandardError; end

    class EvaluationError < Error; end

    class ExpressionEvaluationError < EvaluationError; end

    class FunctionCallError < Error; end
  end
end
