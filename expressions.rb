# Everything returns a value in Ruby, allowing us to chain things in crazy ways

p (p "Hello" unless puts (1..5).to_a.reverse.map(&:to_s).join(",")).upcase

puts a = b = 1 + 2 + 3

# Command expressions

puts `date`
puts `pwd`

# Assignment

2 => x
puts x

a,b = 1,2
p [a, b]
a,b = b,a
p [a, b]

a = 1,2,3,4
p a

a,b = 1,2,3,4
p [a,b]

a, = 1,2,3,4
p a

a,b,c,d,e = *(1..2), 3, *[4,5]
p [a,b,c,d,e]

a, *b = 1,2,3,4,5
p b

a, *b = 1
p b

a, *b, c = *(1..4)
p b

a, * ,z = *("a".."z") 
p "#{a} to #{z}"

a,b = 1
p b

a, (b,c), d = *(1..4)
p [b, c]

a, (b,c), d = 1, [2,3], 4
p [b, c]

a, (b,c), d = 1, [2,3,4], 5
p [b, c]

a, (b,*c), d = 1, [2,3,4], 5
p [b, c]
