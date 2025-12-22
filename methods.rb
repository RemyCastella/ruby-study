# Chapter 5 - Methods

class Dog
    def speak
        puts "Woof!"
    end

    def speak
        puts "Arf!"
    end
end

dog = Dog.new
dog.speak

def endless(arg) = puts arg
endless(42)

lola = Dog.new
def lola.speak = puts "Mi!"
lola.speak

def surround(word, pad_with=word.length/2)
    puts "#{'['*pad_with}#{word}#{']'*pad_with}"
end
surround("rhino")

def rest(num1, *rest)
    p "#{num1}, #{rest}"
end
rest(1,2,3,4,5)

def first_and_last(first, *, last)
    puts "First: #{first}, Last: #{last}"
end
first_and_last(1,2,3,4,5)

# Positional vs keyword arguments

def shirt_sizes(**people)
    p people
end
shirt_sizes(Remy: "M", Nagahama: "L")

# What does three dots do?

def do_something(...)
    # code
end

def address(city:, state:, zip:)
    "I live in #{city}, #{state}, #{zip}"
end
data = { city: "Burlington", state: "Vermont", zip: "05405"}
puts address(**data)

# Passing Procs or anything with to_proc to methods

square = ->(n){ n * n }
p (1..5).map(&square)

p ("a".."f").to_a.map(&:upcase)

# method receiver can be an expression

def ("hello".class).last_upcase(str)
    str[0...-1] + str[-1].upcase
end

puts String.last_upcase("cat")

# enclosed methods

def time
    def time
        def time
            "third time"
        end
        "second time"
    end
    "first time"
end

p time
p time
p time
p time

# computed parameters

def nums(a = 99, b = a + 1)
    [a, b]
end

p nums
p nums(123)

# save navigation

p nil&.upcase
p "test".upcase

# returning multiple values

def method
    return "multiple", "values", "are", "returned"
end

p method

# Aliasing

class Integer
    alias minus -
end

p 5.minus(2)
