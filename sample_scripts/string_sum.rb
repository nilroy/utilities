#!/usr/bin/env ruby

require 'optimist'

class StringSum

  def initialize(input:)
    @input = input.downcase
    @string_map = {
      'a' => 1,
      'b' => 2,
      'c' => 3,
      'd' => 4,
      'e' => 5,
      'f' => 8,
      'g' => 3,
      'h' => 5,
      'i' => 1,
      'j' => 1,
      'k' => 2,
      'l' => 3,
      'm' => 4,
      'n' => 5,
      'o' => 7,
      'p' => 8,
      'q' => 1,
      'r' => 2,
      's' => 3,
      't' => 4,
      'u' => 6,
      'v' => 6,
      'w' => 6,
      'x' => 5,
      'y' => 1,
      'z' => 7
    }
  end

  def string_sum
    sum = 0
    @input.split('').each do |char|
      val = @string_map[char]
      if val.nil?
        val = char.to_i
      end
      sum += val
    end
    l = sum.to_s.split('')
    while true
      if l.count == 1
        puts sum.to_i
        break
      else
        l1 = l.collect {|l| l.to_i}
        sum = 0
        l1.each do |a|
          sum += a
        end
        l = sum.to_s.split('')
        next
      end
    end
  end

end

if __FILE__ == $0

  opts = Optimist.options do
    opt :input, 'The string whose sum is needed', :type => :string, :default => nil
  end

  Optimist.die :input, 'Input string needed' unless opts[:input]

  stringsum = StringSum.new(input: opts[:input])
  stringsum.string_sum
end
