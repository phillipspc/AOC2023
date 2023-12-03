require "minitest/autorun"
require_relative "base"
require_relative "test_helper"

class Day1Part2 < Base
  def self.sample_input
    "two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen"
  end

  def self.sample_output
    281
  end

  def call
    array = input.split("\n")
    regex = /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/

    array.sum do |el|
      first = el.scan(regex).first.first
      last = el.scan(regex).last.first

      first = converted(first)
      last = converted(last)
      (first + last).to_i
    end
  end

  private

  def converted(input)
    case input
    when "one"
      "1"
    when "two"
      "2"
    when "three"
      "3"
    when "four"
      "4"
    when "five"
      "5"
    when "six"
      "6"
    when "seven"
      "7"
    when "eight"
      "8"
    when "nine"
      "9"
    else
      input
    end
  end
end

class Day1Part2Test < Minitest::Test
  include TestHelper
end
