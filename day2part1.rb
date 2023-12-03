require "minitest/autorun"
require_relative "base"
require_relative "test_helper"

class Day2Part1 < Base
  def self.sample_input
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  end

  def self.sample_output
    8
  end

  def call
    games = games_from_input
    games.sum { |game| game.possible? ? game.id : 0 }
  end

  private

  def games_from_input
    input.split("\n").map { |line| Game.new(line) }
  end
end

class Game
  attr_reader :id, :sets

  def initialize(line)
    @id = line.split(":").first.split(" ").last.to_i
    @sets = sets_from_line(line)
  end

  def sets_from_line(line)
    new_line = line.split(": ").last
    new_line.split("; ").map { |counts| Set.new(counts) }
  end

  def possible?
    sets.all?(&:possible?)
  end
end

class Set
  attr_reader :counts

  def initialize(counts)
    @counts = counts.split(", ").map { |c| Count.new(c) }
  end

  def possible?
    counts.all?(&:possible?)
  end
end

class Count
  attr_reader :count, :color

  def initialize(data)
    @count = data.split(" ").first.to_i
    @color = data.split(" ").last
  end

  def possible?
    case color
    when "red"
      count <= 12
    when "green"
      count <= 13
    when "blue"
      count <= 14
    end
  end
end

class Day2Part1Test < Minitest::Test
  include TestHelper
end
