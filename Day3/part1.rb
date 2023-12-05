require "minitest/autorun"
require_relative "../base"
require_relative "../test_helper"

module Day3
  class Part1 < Base
    SAMPLE_OUTPUT = 4361
    SYMBOL_PATTERN = /[^.0123456789]/

    def initialize(...)
      super(...)

      @line_length = nil
      @sum = 0
    end

    def call
      lines.each_with_index do |line, row|
        # just set this once, assume they're all the same
        @line_length = line.length if row.zero?

        previous_line = lines[row - 1] unless row.zero?
        next_line = lines[row + 1] unless row == (lines.length - 1)

        find_part_numbers(line:, row:, previous_line:, next_line:)
      end

      p @sum
    end

    private

    def input_file
      File.join(
        File.dirname(__FILE__),
        "#{test ? "sample_" : ""}input.txt"
      ).freeze
    end

    def find_part_numbers(line:, row:, previous_line: nil, next_line: nil)
      numbers = parse_numbers(line, row)
      lines_to_consider = [previous_line, line, next_line].compact

      numbers.each do |number|
        line_with_symbol =
          lines_to_consider.detect do |l|
            SYMBOL_PATTERN.match?(l[number.range_begin..number.range_end])
          end

        @sum += number.value if line_with_symbol
      end
    end

    def parse_numbers(line, row)
      buffer = []
      numbers = []

      line
        .split("")
        .each_with_index do |el, col|
          if /[^\d]/.match?(el) && buffer.any?
            numbers << Number.new(buffer, row, (col - 1), @line_length)
            buffer = []
          elsif /\d/.match?(el)
            buffer << el
          end
        end

      if buffer.any?
        numbers << Number.new(buffer, row, (@line_length - 1), @line_length)
      end

      fail if line.scan(/\d+/).count != numbers.count

      numbers
    end
  end

  class Number
    def initialize(buffer, row, last_col, line_length)
      @raw = buffer.join("")
      @length = raw.length
      @row = row
      @last_col = last_col
      @first_col = last_col - (@length - 1)
      @line_length = line_length
    end

    attr_reader :raw, :row, :first_col, :last_col, :line_length

    def value
      raw.to_i
    end

    def range_begin
      first_col.zero? ? 0 : first_col - 1
    end

    def range_end
      (last_col + 1) > (line_length - 1) ? last_col : last_col + 1
    end
  end

  class Part1Test < Minitest::Test
    include TestHelper
  end
end
