@magic_counter = 0
@max = 250
@max_depth = 0
@haystack_cache = {}
max_attempts = 100

def magic (remaining, haystack)
  @magic_counter += 1
  depth = @max - remaining.length
  if (
    #@max_depth < depth ||
    @magic_counter.modulo(1000) == 0)
    puts "Depth:#{depth}/#{@max_depth} : Count:#{@magic_counter} : Cache:#{@haystack_cache.length} : Haystack:#{haystack.length}"
  end
  @max_depth = [depth, @max_depth].max

  if(remaining.length == 0)
    return true
  end

  if(!@haystack_cache[haystack.to_sym].nil?)
    #puts "We've been here before, #{remaining[0]}"
    return false
  end

  @haystack_cache[haystack.to_sym] = true

  remaining.each do |n|
    matches = haystack.to_enum(:scan, /(?=(#{n}))/).map { Regexp.last_match }
    if (matches.length === 0)
      return false
    elsif (matches.length === 1)
      inner_remaining = Array.new(remaining)
      inner_remaining.delete(n)
      inner_haystack = String.new(haystack)
      inner_haystack[matches[0].offset(1)[0]..matches[0].offset(1)[1]-1] = '.'
      inner_haystack = inner_haystack.squeeze('.')
      return magic(inner_remaining, inner_haystack)
    end
  end

  result = false
  n = remaining[0]
  matches = haystack.to_enum(:scan, /(?=(#{n}))/).map { Regexp.last_match }

  matches.each do |match|

    inner_remaining = Array.new(remaining)
    inner_remaining = inner_remaining.drop(1)
    inner_haystack = String.new(haystack)
    inner_haystack[match.offset(1)[0]..match.offset(1)[1]-1] = "."
    inner_haystack = inner_haystack.squeeze('.')
    result = result || magic(inner_remaining, inner_haystack)
  end
  result
end

def attempt
  # setup string from 1 to n with a random number missing
  numbers = [*1..@max].shuffle
  missing = numbers.pop
  numbers = numbers.join

  # count all the digits
  expected = [*1..@max].join
  expected_digits = [0,0,0,0,0,0,0,0,0,0]
  digits = [0,0,0,0,0,0,0,0,0,0]

  numbers.chars do |i|
    digits[i.to_i] += 1
  end

  expected.chars do |i|
    expected_digits[i.to_i] += 1
  end

  missing_no = []
  digits.each_with_index do |i, k|
    n = (expected_digits[k.to_i] - digits[k.to_i])
    if (n > 0)
      missing_no.fill(k, missing_no.size, n)
    end
  end

  permutations = []
  raw_permutations = missing_no.permutation.uniq
  raw_permutations.each do |p|
    if p[0] != 0
      permutations.push(p)
    end
  end

  if (permutations.length === 1)
    #puts "Found it! #{missing} #{permutations[0].join}"
    return permutations
  end

  missing_no_2 = []
  permutations.each do |n|
    num = n.join.to_i
    if (num <= @max && !numbers.include?(n.join))
      missing_no_2.push(num)
    end
  end

  if (missing_no_2.length > 0)
    #puts "Found it! #{missing} #{missing_no_2[0]}"
    return missing_no_2
  end

  answers = []
  permutations.each do |permutation|
    n = permutation.join.to_i

    @magic_counter = 0
    @max_depth = 0
    @haystack_cache = {}

    remaining = [*1..@max]
    remaining -= [n]
    remaining = remaining.reverse

    result = magic(remaining, numbers)
    if (result)
      #puts "Found it! #{missing} #{n}"
      answers.push(permutation.join)
    end
  end
  #if (answers.length === 0)
  #  puts numbers
  #  puts "#{permutations}"
  #end

  answers
end

result = 0
multiple = 0
for i in 1..max_attempts
  puts "Attempt #{i}"
  data = attempt
  if (data.length == 1)
    result += 1
  elsif data.length > 1
    multiple +=1
  end
end

percent = 100 * result / max_attempts
puts "Result: #{result}/#{max_attempts} (#{percent}%) found original missing number"
percent = 100 * multiple / max_attempts
puts "Result: #{multiple}/#{max_attempts} (#{percent}%) found multiple valid permutations"

#puts magic([1,2,3],"212133")

#attempt

=begin
n = 777
haystack = "12777777734"
matches = haystack.to_enum(:scan, /(?=(#{n}))/).map { Regexp.last_match }
matches.each do |m|
  puts "#{m.offset(1)[0]} #{m.offset(1)[1]}"
end

puts "#{matches}"
=end
