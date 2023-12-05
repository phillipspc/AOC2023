require_relative "../base"

module Day4
  class Part1 < Base
    SAMPLE_OUTPUT = 13

    def call
      cards = lines.map { |line| Card.new(line) }
      cards.sum(&:points)
    end
  end

  class Card
    def initialize(line)
      @line = line
    end

    attr_reader :line

    def points
      return 0 unless overlap.positive?

      2**(overlap - 1)
    end

    private

    def overlap
      (winning_numbers & my_numbers).count
    end

    def winning_numbers
      numbers_without_card.split("|").first.scan(/\d+/)
    end

    def my_numbers
      numbers_without_card.split("|").last.scan(/\d+/)
    end

    def numbers_without_card
      line.split(":").last.strip
    end
  end
end

p Day4::Part1.call
