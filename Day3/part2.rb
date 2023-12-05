require "minitest/autorun"
require "debug"
require_relative "../base"
require_relative "../test_helper"

module Day3
  class Part2 < Base
    SAMPLE_OUTPUT = 467_835
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

        gears(line:, row:, previous_line:, next_line:)
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

    def gears(line:, row:, previous_line: nil, next_line: nil)
      gears = parse_gears(line, row, previous_line, next_line)

      gears.each { |gear| @sum += gear.ratio if gear.valid? }
    end

    def parse_gears(line, row, previous_line = nil, next_line = nil)
      gears = []

      line
        .split("")
        .each_with_index do |el, col|
          if el == "*"
            gears << Gear.new(@line_length, col, line, previous_line, next_line)
          end
        end

      gears
    end
  end

  class Gear
    def initialize(line_length, col, line, previous_line = nil, next_line = nil)
      @col = col
      @line = line
      @previous_line = previous_line
      @next_line = next_line
      @line_length = line_length
    end

    attr_reader :col, :line, :previous_line, :next_line, :line_length

    def valid?
      lines_to_consider.sum do |line|
        range = line[range_begin..range_end]
        range.scan(/\d+/).count
      end == 2
    end

    def ratio
      numbers =
        lines_with_numbers
          .map { |lwn| GetNumbersForCol.new(lwn, col, line_length).call }
          .flatten
      numbers.first.value * numbers.last.value
    end

    private

    def lines_to_consider
      [line, previous_line, next_line].compact
    end

    def lines_with_numbers
      lines_to_consider
        .select do |line|
          line[range_begin..range_end].scan(/\d+/).count.positive?
        end
        .compact
    end

    def range_begin
      col.zero? ? 0 : col - 1
    end

    def range_end
      col == (line_length - 1) ? col : col + 1
    end
  end

  class GetNumbersForCol
    def initialize(line, col, line_length)
      @line = line
      @col = col
      @line_length = line_length
    end

    attr_reader :line, :col, :line_length

    def call
      numbers.select { |number| number.overlap.include?(col) }
    end

    private

    def numbers
      buffer = []
      numbers = []

      line
        .split("")
        .each_with_index do |el, col|
          if /[^\d]/.match?(el) && buffer.any?
            numbers << Number.new(buffer, (col - 1), @line_length)
            buffer = []
          elsif /\d/.match?(el)
            buffer << el
          end
        end

      if buffer.any?
        numbers << Number.new(buffer, (@line_length - 1), @line_length)
      end

      fail if line.scan(/\d+/).count != numbers.count

      numbers
    end
  end

  class Number
    def initialize(buffer, last_col, line_length)
      @raw = buffer.join("")
      @length = raw.length
      @last_col = last_col
      @first_col = last_col - (@length - 1)
      @line_length = line_length
    end

    attr_reader :raw, :first_col, :last_col, :line_length

    def value
      raw.to_i
    end

    def overlap
      (range_begin..range_end).to_a
    end

    def range_begin
      first_col.zero? ? 0 : first_col - 1
    end

    def range_end
      (last_col + 1) > (line_length - 1) ? last_col : last_col + 1
    end
  end

  # class Part2Test < Minitest::Test
  #   include TestHelper
  # end
end

Day3::Part2.call
