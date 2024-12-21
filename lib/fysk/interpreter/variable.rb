# frozen_string_literal: true

module Fysk
  module Interpreter
    class Variable
      def initialize(value)
        bind(value)
      end

      def eval
        @value
      end

      def bind(value)
        @value = value
      end
    end
  end
end
