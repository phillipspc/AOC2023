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

        if line_with_symbol
          p number.value
          p line_with_symbol[number.range_begin..number.range_end]
          p "---------"
          @sum += number.value
        end
      end
    end

    def parse_numbers(line, row)
      raw = line.scan(/\d+/)
      raw.map { |num| Number.new(num, row, line.index(num), @line_length) }
    end
  end

  class Number
    def initialize(raw, row, first_col, line_length)
      @raw = raw
      @length = raw.length
      @row = row
      @first_col = first_col
      @last_col = first_col + @length - 1
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

  # class Part1Test < Minitest::Test
  #   include TestHelper
  # end
end

Day3::Part1.call
