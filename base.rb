class Base
  def self.call(input)
    new(input).call
  end

  def initialize(input)
    @input = input
  end

  attr_reader :input
end
