# frozen_string_literal: true

RSpec.describe Fysk::Interpreter do
  describe Fysk::Interpreter::Variable do
    before do
      @variable = Fysk::Interpreter::Variable.new(Fysk::Interpreter::Constant.new(1))
    end

    describe "#eval" do
      it "returns value correctly" do
        expect(@variable.eval.eval).to eq 1
      end
    end

    describe "#bind" do
      it "binds value correctly" do
        @variable.bind(Fysk::Interpreter::Constant.new(2))

        expect(@variable.eval.eval).to eq 2
      end
    end
  end
end
