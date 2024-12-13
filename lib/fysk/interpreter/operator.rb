# frozen_string_literal: true

module Fysk
  module Interpreter
    class Operator
      class << self
        def calc(*_)
          raise NotImplementedError
        end
      end
    end

    # rubocop:disable Naming/MethodParameterName

    class BinaryOperator < Operator
      class << self
        def calc(l, r)
          raise NotImplementedError
        end
      end
    end

    class PlusOperator < BinaryOperator
      class << self
        def calc(l, r)
          l + r
        end
      end
    end

    class MinusOperator < BinaryOperator
      class << self
        def calc(l, r)
          l - r
        end
      end
    end

    class MultiOperator < BinaryOperator
      class << self
        def calc(l, r)
          l * r
        end
      end
    end

    class DivideOperator < BinaryOperator
      class << self
        def calc(l, r)
          l.div(r)
        end
      end
    end

    # rubocop:enable Naming/MethodParameterName
  end
end
