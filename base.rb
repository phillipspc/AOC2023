require "debug"
class Base
  def self.call
    new.call
  end

  def self.test
    new(test: true).call
  end

  def initialize(test: false)
    @test = test
    @lines = []
    File.foreach(input_file) { |line| lines << line.gsub("\n", "") }
  end

  attr_reader :test, :lines

  def input_file
    File.join(
      (self.class.to_s.split("::").first),
      "#{test ? "sample_" : ""}input.txt"
    ).freeze
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
