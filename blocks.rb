# Ch4 - Blocks and enumeration

# Review of word frequency, tally, and tap

words = 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Repudiandae dolore facilis commodi, sequi ratione aliquam sit in rerum cupiditate molestias asperiores itaque ad quod inventore vel tempora eveniet iste nihil voluptates odio sint! Autem, eius sed aliquam saepe ut voluptatem architecto repudiandae. Magni magnam explicabo nesciunt delectus ipsam obcaecati libero.'
word_list = words.downcase.scan(/[\w']+/)
word_frequency = word_list.tally
puts word_frequency
  .sort_by { |_word, count| count }
  .reverse
  .map { |word, count| "#{word}: #{count}" }
  .tap { |results| puts results.first }
  .first(5)

# Yield

def twice
  yield
  yield
end

twice { puts 'Hello' }

def my_map(arr)
  new_arr = []
  arr.each do |item|
    new_arr << yield(item)
  end
  new_arr
end

p my_map([1, 2, 3]) { |item| item * 2 }

def fibonacci(num)
  i1 = 1
  i2 = 1
  while i1 <= num
    yield(i1)
    i1, i2 = i2, (i1 + i2)
  end
end

fibonacci(100) { |num| puts num }

# Reduce and method shortcuts

p (1..5).to_a.reduce(:*)

# Procs

def block_to_proc(&block)
  block
end

prc_1 = block_to_proc { |val| puts "The answer to life is: #{val}" }
prc_1.call(42)

prc_2 = ->(val) { puts "The answer to life is #{val}" }
prc_2.call(43)

prc_3 = ->(val) { puts "The answer to life is: #{val}" }
prc_3.call(44)

## See p.187 for lambda vs proc vs Proc.new

crazy_proc = lambda do |a, *b, &block|
  puts "a = #{a}"
  puts "b = #{b}"
  block.call
end

crazy_proc.call(1, 2, 3, 4) { puts 'And this is the block!' }

# Enumerator (external iterator)

a = ['lorem', 'ipsum', 1, 2, 3]

enum_1 = a.to_enum
puts enum_1.next
puts enum_1.next

## Also works with hashes

enum_2 = a.reverse_each
puts enum_2.next
puts enum_2.next

# The loop method

short_enum = [1, 2, 3].to_enum
long_enum = ('a'..'z').to_enum

loop do
  puts "#{short_enum.next}. #{long_enum.next}"
end

string = 'The Enumerable module has the each_with_index method. If we want to use each_with_index with a string, we can first turn it into an Enumerable via each_char, without a block.'

string.each_char.first(3).each_with_index { |char, index| puts "#{index}. #{char}" }

p string.enum_for(:split, " ").to_a

# Generators

exponential = Enumerator.produce(5){ |num| num * 2 }
3.times{ puts exponential.next }

triangular = Enumerator.produce([1, 2]) do |number, count|
  [number + count, count + 1]
end
5.times { puts triangular.next.first }

# enumerable methods can also be used on Enumerator objects

p exponential.first(5)

# lazy Enumerables

class InfiniteStream
  def all
    Enumerator.produce(0){ |num| num += 1}.lazy
  end
end

p InfiniteStream.new.all
  .select{ (_1 % 3).zero? }
  .first(10)

multiples_of_three = ->(n){ (n % 3).zero? }
p InfiniteStream.new.all
  .select(&multiples_of_three)
  .first(3)