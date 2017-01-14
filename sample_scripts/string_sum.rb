#!/usr/bin/env ruby

require 'trollop'

class StringSum

  def initialize(input:)
    @input = input.downcase
    @string_map = {
      'a' => 1,
      'b' => 2,
      'c' => 3,
      'd' => 4,
      'e' => 5,
      'f' => 6,
      'g' => 7,
      'h' => 8,
      'i' => 9,
      'j' => 10,
      'k' => 11,
      'l' => 12,
      'm' => 13,
      'n' => 14,
      'o' => 15,
      'p' => 16,
      'q' => 17,
      'r' => 18,
      's' => 19,
      't' => 20,
      'u' => 21,
      'v' => 22,
      'w' => 23,
      'x' => 24,
      'y' => 25,
      'z' => 26
    }
  end

  def string_sum
    sum = 0
    @input.split('').each do |char|
      val = @string_map[char]
      if val.nil?
        val = val.to_i
      end
      sum += val
    end
    puts sum
  end

end

if __FILE__ == $0

  opts = Trollop::options do
    opt :input, 'The string whose sum is needed', :type => :string, :default => nil
  end

  Trollop::die :input, 'Input string needed' unless opts[:input]

  stringsum = StringSum.new(input: opts[:input])
  stringsum.string_sum
end
