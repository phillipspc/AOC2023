require "minitest/autorun"
require_relative "base"
require_relative "test_helper"

class Day2Part2 < Base
  def self.sample_input
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  end

  def self.sample_output
    2286
  end

  def call
    games = games_from_input
    games.sum(&:power)
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

  def power
    sets.map(&:red_count).max * sets.map(&:blue_count).max *
      sets.map(&:green_count).max
  end
end

class Set
  attr_reader :counts

  def initialize(counts)
    @counts = counts.split(", ").map { |c| Count.new(c) }
  end

  def red_count
    counts.select { |c| c.red? }.first&.count || 0
  end

  def blue_count
    counts.select { |c| c.blue? }.first&.count || 0
  end

  def green_count
    counts.select { |c| c.green? }.first&.count || 0
  end
end

class Count
  attr_reader :count, :color

  def initialize(data)
    @count = data.split(" ").first.to_i
    @color = data.split(" ").last
  end

  def red?
    color == "red"
  end

  def blue?
    color == "blue"
  end

  def green?
    color == "green"
  end
end

class Day2Part2Test < Minitest::Test
  include TestHelper
end
