require_relative "../base"

class Range
  def overlap?(range)
    self.begin <= range.end && range.begin <= self.end
  end

  def overlap(range)
    return unless overlap?(range)

    ([self.begin, range.begin].max..[self.end, range.end].min)
  end
end

module Day5
  class Part2 < Base
    SAMPLE_OUTPUT = 46

    def call
      @input = nil
      humidity_to_location_map.submaps.detect do |submap|
        debugger
        input_range =
          submap.deep_input_ranges.detect do |ir|
            seed_ranges.detect { |sr| sr.overlap?(ir) }
          end
        next unless input_range

        seed_range = seed_ranges.detect { |sr| sr.overlap?(input_range) }
        @input = seed_range.overlap(input_range).begin
      end

      # p "got an input: #{@input}"

      seed_to_soil_map.deep_output(@input)

      # seed_to_soil_map
      #   .call(@input)
      #   .then { |n| soil_to_fertilizer_map.call(n) }
      #   .then { |n| fertilizer_to_water_map.call(n) }
      #   .then { |n| water_to_light_map.call(n) }
      #   .then { |n| light_to_temperature_map.call(n) }
      #   .then { |n| temperature_to_humidity_map.call(n) }
      #   .then { |n| humidity_to_location_map.call(n) }
    end

    private

    def seed_ranges
      @seed_ranges ||=
        begin
          numbers = lines.first.split(": ").last.split(" ").map(&:to_i)
          ranges = []
          until numbers.none?
            start, range = numbers.shift(2)
            ranges << (start..(start + range - 1))
          end

          ranges
        end
    end

    def seed_to_soil_map
      @seed_to_soil_map ||= get_section(name: "seed-to-soil map:")
    end

    def soil_to_fertilizer_map
      @soil_to_fertilizer_map ||=
        get_section(
          name: "soil-to-fertilizer map:",
          parent_map: seed_to_soil_map
        )
    end

    def fertilizer_to_water_map
      @fertilizer_to_water_map ||=
        get_section(
          name: "fertilizer-to-water map:",
          parent_map: soil_to_fertilizer_map
        )
    end

    def water_to_light_map
      @water_to_light_map ||=
        get_section(
          name: "water-to-light map:",
          parent_map: fertilizer_to_water_map
        )
    end

    def light_to_temperature_map
      @light_to_temperature_map ||=
        get_section(
          name: "light-to-temperature map:",
          parent_map: water_to_light_map
        )
    end

    def temperature_to_humidity_map
      @temperature_to_humidity_map ||=
        get_section(
          name: "temperature-to-humidity map:",
          parent_map: light_to_temperature_map
        )
    end

    def humidity_to_location_map
      @humidity_to_location_map ||=
        get_section(
          name: "humidity-to-location map:",
          parent_map: temperature_to_humidity_map
        )
    end

    def get_section(name:, parent_map: nil)
      section_start = lines.index(name) + 1
      section_lines = lines.drop(section_start)
      line_break = section_lines.index("")
      section_lines =
        if line_break
          lines[section_start..(section_start + line_break - 1)]
        else
          lines[section_start..]
        end
      Map.new(lines: section_lines, name:, parent_map:)
    end
  end

  class Map
    def initialize(lines:, name:, parent_map: nil)
      @name = name
      @submaps =
        lines
          .map do |line|
            output_start, input_start, count = line.split(" ").map(&:to_i)
            Submap.new(output_start:, input_start:, count:, name:, parent_map:)
          end
          .sort_by(&:output_start)
      @parent_map = parent_map
      fill_in_default_submaps
    end

    attr_reader :submaps, :parent_map, :name

    def deep_output(input)
      submap = submaps.detect { |submap| submap.covers?(input) }
      if submap.is_bottom
        submap.output(input)
      else
        submap.parent_map.deep_output(input)
      end
    end

    def submaps_for(input_range)
      submaps.select { |submap| submap.output_range.overlap?(input_range) }
    end

    def fill_in_default_submaps
      @gap_start = 0
      defaults =
        submaps.filter_map do |submap|
          if submap.input_start == @gap_start
            @gap_start = submap.input_stop + 1
            next
          end

          start = @gap_start
          count = submap.input_start - @gap_start

          default =
            Submap.new(
              output_start: start,
              input_start: start,
              count: count,
              name:,
              parent_map:
            )

          @gap_start = submap.input_stop + 1
          default
        end

      @submaps += defaults
      @submaps = submaps.sort_by(&:output_start)
    end
  end

  class Submap
    def initialize(output_start:, input_start:, count:, name:, parent_map: nil)
      @output_start = output_start
      @input_start = input_start
      @count = count
      @name = name
      @parent_map = parent_map
    end

    attr_reader :output_start, :input_start, :count, :name, :parent_map

    def deep_input_ranges(constraint = nil)
      if is_top
        [constraint ? input_range.overlap(constraint) : input_range]
      else
        submaps = parent_map.submaps_for(input_range)
        submaps
          .flat_map do |submap|
            deep_constraint = submap.output_range.overlap(input_range)
            submap.deep_input_ranges(deep_constraint)
          end
          .uniq
          .compact
      end
    end

    def is_top?
      name == "soil-to-fertilizer map:"
    end

    def is_bottom?
      name == "humidity-to-location map:"
    end

    def covers?(input)
      input_range.cover?(input)
    end

    def output(input)
      output_start + (input - input_start)
    end

    def input_range
      (input_start..input_stop)
    end

    def output_range
      (output_start..output_stop)
    end

    def input_stop
      input_start + count - 1
    end

    def output_stop
      output_start + count - 1
    end
  end
end

# p Day5::Part2.call
