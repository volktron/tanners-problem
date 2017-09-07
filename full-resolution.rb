@magic_counter = 0
@max = 250
@max_depth = 0
@haystack_cache = {}

def magic (remaining, haystack)
  @magic_counter += 1
  depth = @max - remaining.length
  if (
    #@max_depth < depth ||
    @magic_counter.modulo(100000) == 0)
    puts "Depth:#{depth}/#{@max_depth} : Count:#{@magic_counter} : Cache:#{@haystack_cache.length} : Haystack:#{haystack.length}"
  end
  @max_depth = [depth, @max_depth].max

  if(remaining.length == 0)
    return true
  end

  if(!@haystack_cache[haystack.to_sym].nil?)
    return false
  end

  needle = remaining[0]
  matches = haystack.to_enum(:scan, /#{needle}/).map { Regexp.last_match }

  if(matches.length == 0)
    return false
  end

  @haystack_cache[haystack.to_sym] = true

  result = false
  matches.each do |match|

  inner_remaining = Array.new(remaining)
  inner_remaining = inner_remaining.drop(1)
  inner_haystack = String.new(haystack)
  inner_haystack[match.offset(0)[0]..match.offset(0)[1]-1] = '.'
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
    puts "Found it! #{missing} #{permutations[0].join}"
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
    puts "Found it! #{missing} #{missing_no_2[0]}"
    return missing_no_2
  end

  tries = 0
  permutations.each do |permutation|
    n = permutation.join.to_i
    if (tries == permutations.length - 1)
      puts "Found it! #{missing} #{n}"
      return [permutation.join]
    end

    @magic_counter = 0
    @max_depth = 0
    @haystack_cache = {}

    remaining = [*1..@max]
    remaining -= [n]
    remaining = remaining.reverse

    result = magic(remaining, numbers)
    if (result)
      puts "Found it! #{missing} #{n}"
      return [permutation.join]
    end

    tries += 1
  end
  []
end

max_attempts = 10
result = 0
for i in 1..max_attempts
  puts "Attempt #{i}"
  data = attempt
  result = data.length > 0 ? result + 1 : result
end

percent = 100 * result / max_attempts
puts "Result: #{percent}% success"

#puts magic([1,2,3],"212133")
