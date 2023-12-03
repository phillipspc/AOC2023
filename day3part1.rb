require "minitest/autorun"
require_relative "base"
require_relative "test_helper"

class Day3Part1 < Base
  SYMBOL_PATTERN = /[^.0123456789]/

  def self.sample_input
    "...733.......289..262.....520..................161.462..........450.........................183.............................................
    ....*....................*.............707.352....*............/.....................801...@...............333..196........484.635......287.
    ....42.........131....913..............*......&..........634..................440..&...............83.....@...........404$..=....*..423.*..."
  end

  def self.sample_output
    6666
  end

  def initialize(input)
    super

    @line_length = lines.first.length
    @sum = 0
  end

  def call
    fail unless lines.all? { |l| l.length == @line_length }

    lines.each_with_index do |line, row|
      previous_line = lines[row - 1] unless row.zero?
      next_line = lines[row + 1] unless row == lines.length

      find_part_numbers(line:, row:, previous_line:, next_line:)
    end

    @sum
  end

  private

  def find_part_numbers(line:, row:, previous_line: nil, next_line: nil)
    numbers = parse_numbers(line, row)
    lines = [previous_line, line, next_line].compact

    numbers.each do |number|
      line_with_symbol =
        lines.detect do |l|
          SYMBOL_PATTERN.match?(l[number.range_begin..number.range_end])
        end

      if line_with_symbol
        p number.value
        p line_with_symbol[number.range_begin..number.range_end]
        p "---------"
        @sum += number.value
      end
    end
  end

  def parse_numbers(line, row)
    buffer = []
    numbers = []

    line
      .split("")
      .each_with_index do |el, col|
        if el == "." && buffer.any?
          numbers << Number.new(buffer, row, (col - 1), @line_length)
          buffer = []
        elsif /\d/.match?(el)
          buffer << el
        end
      end

    numbers
  end
end

class Number
  def initialize(buffer, row, last_col, line_length)
    @buffer = buffer
    @length = buffer.length
    @row = row
    @last_col = last_col
    @first_col = last_col - (@length - 1)
    @line_length = line_length
  end

  attr_reader :buffer, :row, :last_col, :line_length, :first_col

  def value
    buffer.join.to_i
  end

  def range_begin
    first_col.zero? ? 0 : first_col - 1
  end

  def range_end
    (last_col + 1) > (line_length - 1) ? last_col : last_col + 1
  end
end

class Day3Part1Test < Minitest::Test
  include TestHelper
end
