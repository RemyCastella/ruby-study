# Everything returns a value in Ruby, allowing us to chain things in crazy ways

p (p "Hello" unless puts (1..5).to_a.reverse.map(&:to_s).join(",")).upcase

puts a = b = 1 + 2 + 3

year = 2025
result = case year
    when 1926..1989
        "Showa"
    when 1989..2019
        "Heisei"
    when 2019..2026
        "Reiwa"
    else
        "Too old!"
    end
puts result

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

# Conditionals

puts false && 99
puts "" && 99
puts false || 42
puts 0 || 42

result1 = "a" && "b"
result2 = "a" and "b"
puts result1
puts result2

val ||= "default"
puts val

puts !!"Ruby"

puts defined? c
puts defined? Object

a = "string"
b = "string"

puts (2 == 2.0)
puts a.eql? b
puts a.equal? b
puts (0..10) === 7
puts case 7
    when (0..10)
        "Its a match!"
    end

# Safe navigation

data = {}

p data[:name]&.upcase

data[:name] = "remy"

p data[:name]&.upcase

# Loops and iterators

a = 1

a *= 2 until a > 50
puts a

a -= 12 while a > 0
puts a

class Eras
    def each
        yield "Meiji"
        yield "Taisho"
        yield "Showa"
        yield "Heisei"
        yield "Reiwa"
    end
end

eras = Eras.new

for era in eras
    puts era
end


x = "value 1"
y = "value 2"

[1,2,3].each do |x|
    y = x + 1
end

p [x, y]

# Pattern matching

puts ("string" in String)
puts (3 in (1..5))
puts (["table", 8, "chair"] in [String, 1..10, /\w+/])
puts ({name: "Remy", nationality: "Japan"} in {nationality: String})
puts ([1, "Japan", 4, "Sushi", 8] in [*, "Japan", 4, *])

[1, "potato", 2, "potato"] => [first, String, second, String]
p [first, second]

def pick_a_card(cards)
    case cards
    in [*, {rank:}, {rank: ^rank}, *]
        "You have a pair of #{rank}s"
    else
        "You have no interesting cards"
    end
end

p pick_a_card([
    {rank: "Ace", suit: "Hearts"},
    {rank: "Ace", suit: "Diamonds"},
    {rank: "Queen", suit: "Clubs"}
])

