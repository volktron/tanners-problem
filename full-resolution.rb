@magic_counter = 0
def magic (remaining, haystack)
  @magic_counter += 1

  if(remaining.length == 0)
    return true
  end

  needle = remaining[0]
  matches = haystack.to_enum(:scan, /#{needle}/).map { Regexp.last_match }

  if(matches.length == 0)
    return false
  end

  result = false
  matches.each do |match|
    inner_remaining = Array.new(remaining)
    inner_remaining = inner_remaining.drop(1)

    begin
      inner_haystack = haystack
      inner_haystack[match.offset(0)[0]..match.offset(0)[1]-1] = '.'
      result = result || magic(inner_remaining, inner_haystack)
    rescue
      puts inner_haystack
      puts inner_remaining.length
      exit
    end
  end
  result
end

def attempt
  max = 250

  # setup string from 1 to n with a random number missing
  numbers = [*1..max].shuffle
  numbers.pop
  numbers = numbers.join

  # count all the digits
  expected = [*1..max].join
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
    return permutations
  end

  missing_no_2 = []
  permutations.each do |n|
    num = n.join.to_i
    if (num <= max && !numbers.include?(n.join))
      missing_no_2.push(num)
    end
  end

  if (missing_no_2.length > 0)
    return missing_no_2
  end

  permutations.each do |permutation|
    remaining = [*1..max]
    remaining -= [permutation.join.to_i]

    if (magic(remaining, numbers))
      return [permutation.join]
    end
  end
  []
end

max_attempts = 1
result = 0
for i in 1..max_attempts
  data = attempt
  result = data.length == 1 ? result + 1 : result
end

percent = 100 * result / max_attempts
puts "Result: #{percent}% success"

#puts magic([1,2,3],"212133")
