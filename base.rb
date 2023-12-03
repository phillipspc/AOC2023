class Base
  def self.call(input)
    new(input).call
  end

  def initialize(input)
    @input = input
  end

  attr_reader :input

  private

  def lines
    @lines ||= input.split("\n").map(&:strip)
  end
end

# template:
#
# require "minitest/autorun"
# require_relative "base"
# require_relative "test_helper"
#
# class Day3Part1 < Base
#   def self.sample_input
#   end

#   def self.sample_output
#   end

#   def call
#   end
# end

# class Day3Part1Test < Minitest::Test
#   include TestHelper
# end
