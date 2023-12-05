require_relative "../base"

module Day4
  class Part2 < Base
    SAMPLE_OUTPUT = 30

    def call
      @total = 0
      @queue = []
      @cards_hash =
        lines
          .map
          .with_index { |line, i| [(i + 1), Card.new(line, (i + 1))] }
          .to_h

      @cards_hash.values.each_with_index { |card, i| }

      @total
    end

    def process_card(card, original:)
      matches, copies = card.process
      @total += matches
      @total += 1 if original
      @queue += copies
      @queue.flatten
    end
  end

  class Card
    def initialize(line, num)
      @line = line
      @num = num
      @copies = []
    end

    attr_reader :line, :num, :copies

    def process
      self.copies = (matches.positive? ? ((num + 1)..(num + matches)).to_a : [])
      [matches, copies]
    end

    private

    def matches
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

p Day4::Part2.call
