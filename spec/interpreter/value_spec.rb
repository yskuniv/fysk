# frozen_string_literal: true

RSpec.describe Fysk::Interpreter do
  describe Fysk::Interpreter::Array do
    before do
      @array = Fysk::Interpreter::Array.new(
        [
          Fysk::Interpreter::Constant.new(1),
          Fysk::Interpreter::Constant.new(2),
          Fysk::Interpreter::Constant.new(3),
          Fysk::Interpreter::Constant.new(4)
        ]
      )
    end

    describe "#eval" do
      it "returns just the given array" do
        expect(@array.eval.map(&:eval)).to eq [1, 2, 3, 4]
      end
    end

    describe "#[]" do
      it "returns the item at the specified index" do
        expect(@array[0].eval).to eq 1
        expect(@array[1].eval).to eq 2
        expect(@array[2].eval).to eq 3
        expect(@array[3].eval).to eq 4
      end
    end

    describe "#[]=" do
      it "returns the item at the specified index" do
        @array[0] = Fysk::Interpreter::Constant.new(2)
        @array[1] = Fysk::Interpreter::Constant.new(3)
        @array[2] = Fysk::Interpreter::Constant.new(4)
        @array[3] = Fysk::Interpreter::Constant.new(5)

        expect(@array.eval.map(&:eval)).to eq [2, 3, 4, 5]
      end
    end
  end

  describe Fysk::Interpreter::Constant do
    before do
      @c = Fysk::Interpreter::Constant.new(1)
    end

    describe "#eval" do
      it "returns just the given constant" do
        expect(@c.eval).to eq 1
      end
    end
  end
end
