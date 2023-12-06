require_relative "../base"

module Day5
  class Part1 < Base
    SAMPLE_OUTPUT = 35

    def call
      seeds
        .map do |seed|
          seed_to_soil_map
            .call(seed)
            .then { |n| soil_to_fertilizer_map.call(n) }
            .then { |n| fertilizer_to_water_map.call(n) }
            .then { |n| water_to_light_map.call(n) }
            .then { |n| light_to_temperature_map.call(n) }
            .then { |n| temperature_to_humidity_map.call(n) }
            .then { |n| humidity_to_location_map.call(n) }
        end
        .min
    end

    private

    def seeds
      @seeds ||= lines.first.split(": ").last.split(" ").map(&:to_i)
    end

    def seed_to_soil_map
      @seed_to_soil_map ||= get_section("seed-to-soil map:")
    end

    def soil_to_fertilizer_map
      @soil_to_fertilizer_map ||= get_section("soil-to-fertilizer map:")
    end

    def fertilizer_to_water_map
      @fertilizer_to_water_map ||= get_section("fertilizer-to-water map:")
    end

    def water_to_light_map
      @water_to_light_map ||= get_section("water-to-light map:")
    end

    def light_to_temperature_map
      @light_to_temperature_map ||= get_section("light-to-temperature map:")
    end

    def temperature_to_humidity_map
      @temperature_to_humidity_map ||=
        get_section("temperature-to-humidity map:")
    end

    def humidity_to_location_map
      @humidity_to_location_map ||= get_section("humidity-to-location map:")
    end

    def get_section(name)
      section_start = lines.index(name) + 1
      section_lines = lines.drop(section_start)
      line_break = section_lines.index("")
      section_lines =
        if line_break
          lines[section_start..(section_start + line_break - 1)]
        else
          lines[section_start..]
        end
      Map.new(section_lines, name)
    end
  end

  class Map
    def initialize(lines, name)
      @sub_maps = lines.map { |l| SubMap.new(l) }.sort_by(&:input_start)
      @name = name
    end

    attr_reader :sub_maps

    def call(input)
      sub_maps.each do |sub_map|
        next unless sub_map.covers?(input)

        return sub_map.output(input)
      end

      input
    end
  end

  class SubMap
    def initialize(line)
      @first, @middle, @last = line.split(" ").map(&:to_i)
    end

    attr_reader :first, :middle, :last

    def covers?(input)
      input.between?(input_start, input_stop)
    end

    def output(input)
      first + (input - input_start)
    end

    def input_range
      (input_start..input_stop).to_a
    end

    def input_start
      middle
    end

    private

    def input_stop
      middle + last - 1
    end

    def output_start
      first
    end

    def output_stop
      first + last - 1
    end
  end
end

p Day5::Part1.call
