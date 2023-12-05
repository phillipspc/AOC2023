require_relative "../base"

module Day4
  class Part2 < Base
    SAMPLE_OUTPUT = 30

    def call
      @counts = Hash.new(0)
      lines.map.with_index do |line, i|
        card_num = i + 1
        card = Card.new(line, card_num, @counts)
        @counts = card.new_counts
      end

      @counts.values.sum
    end
  end

  class Card
    def initialize(line, num, counts)
      @line = line
      @num = num
      @counts = counts
    end

    attr_reader :line, :num, :counts

    def new_counts
      counts[num] += 1
      return counts unless matches.positive?

      copies_range.each { |range_num| counts[range_num] += (1 * counts[num]) }

      counts
    end

    private

    def matches
      (winning_numbers & my_numbers).count
    end

    def copies_range
      ((num + 1)..(num + matches)).to_a
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

p Day4::Part2.call
