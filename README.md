# Notes from Programming Ruby 3.3

My notes from reading *Programming Ruby 3.3* by Noel Rappin.

## basic_io.rb

### I/O Basics and the Kernel Module

I/O related methods are implemented in the Kernel module (`gets`, `open`, `print`, `puts`, `readline`, etc.) and are available to all objects. Ruby also has dedicated IO classes for bidirectional channels between programs and external resources.

```ruby
p IO.ancestors    # See the IO class hierarchy
p IO.subclasses   # See IO subclasses
```

### File Operations

Creating and working with files using different modes:

```ruby
# Create a new file (can't use "r" mode for new files)
file = File.new("file_name", "w")
file.close

# Common file modes: "r", "w", "a", "r+", "w+", "a+"

# Block form automatically closes the file
File.open("testfile.txt", "w+") do |file|
    file.write "Hello!"
    file.each_byte  # iterate bytes
    file.each_line  # iterate lines
end

# Read file line by line
File.foreach("testfile.txt") { |line| puts line }

# Read entire file as string or array of lines
str = IO.read("testfile.txt")
arr = IO.readlines("testfile.txt")

# Get absolute path
puts File.realpath("testfile.txt")
```

### Standard Output and open-uri

```ruby
# Writing to stdout
$stdout << 99 << " red balloons" << "\n"

# Using open-uri for HTTP requests
require "open-uri"

url = "https://www.ruby-dev.jp/"
URI.open(url) do |f|
    puts f.read.scan(/<h1 class=".*?">.*?<\/h1>/m).uniq
end
```

---

## blocks.rb

### Word Frequency with tally and tap

```ruby
words = 'Lorem ipsum dolor sit amet...'
word_list = words.downcase.scan(/[\w']+/)
word_frequency = word_list.tally
puts word_frequency
  .sort_by { |_word, count| count }
  .reverse
  .map { |word, count| "#{word}: #{count}" }
  .tap { |results| puts results.first }
  .first(5)
```

### Yield

The `yield` keyword passes control to a block:

```ruby
def twice
  yield
  yield
end

twice { puts 'Hello' }  # Prints "Hello" twice

# Passing values to blocks
def my_map(arr)
  new_arr = []
  arr.each do |item|
    new_arr << yield(item)
  end
  new_arr
end

p my_map([1, 2, 3]) { |item| item * 2 }  # => [2, 4, 6]
```

### Fibonacci Generator with Yield

```ruby
def fibonacci(num)
  i1 = 1
  i2 = 1
  while i1 <= num
    yield(i1)
    i1, i2 = i2, (i1 + i2)
  end
end

fibonacci(100) { |num| puts num }
```

### Reduce and Method Shortcuts

```ruby
p (1..5).to_a.reduce(:*)  # => 120 (factorial)
```

### Procs and Lambdas

Procs are blocks stored as objects:

```ruby
# Converting block to proc
def block_to_proc(&block)
  block
end

prc_1 = block_to_proc { |val| puts "The answer is: #{val}" }
prc_1.call(42)

# Lambda syntax
prc_2 = ->(val) { puts "The answer is #{val}" }
prc_2.call(43)

# Lambda with complex parameters
crazy_proc = lambda do |a, *b, &block|
  puts "a = #{a}"
  puts "b = #{b}"
  block.call
end

crazy_proc.call(1, 2, 3, 4) { puts 'And this is the block!' }
```

### Enumerators (External Iterators)

```ruby
a = ['lorem', 'ipsum', 1, 2, 3]
enum_1 = a.to_enum
puts enum_1.next  # => "lorem"
puts enum_1.next  # => "ipsum"

# Reverse enumerator
enum_2 = a.reverse_each
puts enum_2.next  # => 3
```

### The Loop Method

```ruby
short_enum = [1, 2, 3].to_enum
long_enum = ('a'..'z').to_enum

loop do
  puts "#{short_enum.next}. #{long_enum.next}"
end
# Automatically stops when short_enum is exhausted
```

### Generators with Enumerator.produce

```ruby
# Exponential generator
exponential = Enumerator.produce(5) { |num| num * 2 }
3.times { puts exponential.next }  # => 5, 10, 20

# Triangular numbers
triangular = Enumerator.produce([1, 2]) do |number, count|
  [number + count, count + 1]
end
5.times { puts triangular.next.first }
```

### Lazy Enumerables

```ruby
class InfiniteStream
  def all
    Enumerator.produce(0) { |num| num += 1 }.lazy
  end
end

p InfiniteStream.new.all
  .select { (_1 % 3).zero? }
  .first(10)

# Using a proc
multiples_of_three = ->(n) { (n % 3).zero? }
p InfiniteStream.new.all
  .select(&multiples_of_three)
  .first(3)
```

---

## core_data_types.rb

### Date and Time

```ruby
time = Time.now

puts time.year, time.month, time.day, time.sec, time.subsec
puts time.nsec, time.usec  # nano and microseconds
puts time.wednesday?       # day of week check
puts time.yday             # day of year

puts time + 3600           # add 1 hour (in seconds)
puts time.to_f, time.to_i  # seconds since Unix Epoch
```

### Numeric Methods

```ruby
puts 6.div(2)    # => 3 (integer division)
puts 6.fdiv(2)   # => 3.0 (float division)
puts 4.lcm(30)   # => 60 (least common multiple)
puts 111.gcd(12) # => 3 (greatest common divisor)
```

### String Methods

```ruby
str = "This is an example sentence"

# Counting characters
puts str.count("s")      # count 's' characters
puts str.count("sa")     # count 's' and 'a'
puts str.count("a-f")    # count range a through f
puts str.count("^A-Ra-r ") # count chars NOT in range

# Finding positions
puts str.index(/[a-z]/)  # first lowercase letter position
puts str.index("e")      # first 'e' position
puts str.index("e", 11)  # 'e' starting from position 11
puts str.rindex("e")     # last 'e' position

# Checking content
puts str.include?("f")
puts str.match?(/[A-Z]/)
puts str.start_with?("T")
puts str.end_with?("w")

# Slicing
puts str[1..3]         # => "his"
puts str[1,5]          # => "his i"
puts str.slice(1..3)

# Iterating
str2.each_char { |c| c.upcase }
str2.each_byte { |b| p b }
str2.each_codepoint { |c| p c }

# Scanning and splitting
p str.scan(/\s.{1}/)   # find patterns
p str.split            # split on whitespace
p str.partition("s")   # split around first match
p str.rpartition("s")  # split around last match

# Modifying
p str.insert(8, "just ")
p str.delete("i")
p str.gsub(/[aeiou]/, "*")
p str.tr("aeiou", "$")
p "hellllllo".squeeze("l")  # => "helo"

# Formatting
p "div".ljust(8)       # left justify
p "div".center(8)      # center
p "div".rjust(8)       # right justify
p "div".center(8, "-") # center with custom padding

p str.swapcase
p str2.reverse
p :symbol.upcase       # symbols have case methods too
```

---

## exceptions.rb

### Exception Hierarchy

```ruby
puts Exception.subclasses
puts StandardError.subclasses
# StandardErrors are captured by regular Ruby processes
# Always subclass StandardError for custom exceptions
```

### Custom Exceptions

```ruby
class MissingUserError < StandardError
end
```

### Error Handling

```ruby
string = "5 * 7"

begin
    result = eval string
rescue SyntaxError, NameError => e
    print "String doesn't compile:" + e
rescue StandardError => e
    print "Error running script:" + e
else
    puts result  # runs if no exception
ensure
    puts "I am always run"  # always executes
end
```

### Raising Exceptions

```ruby
names = %w[Jon Marcus Maria Carl]
index = 5

if index >= names.count
    raise IndexError, "Index (#{index}) is too big", caller
else
    puts names[index]
end
```

---

## expressions.rb

### Everything Returns a Value

```ruby
# Chaining expressions
p (p "Hello" unless puts (1..5).to_a.reverse.map(&:to_s).join(",")).upcase

# Multiple assignment
puts a = b = 1 + 2 + 3
```

### Case Expressions

```ruby
year = 2025
result = case year
    when 1926..1989 then "Showa"
    when 1989..2019 then "Heisei"
    when 2019..2026 then "Reiwa"
    else "Too old!"
end
puts result
```

### Command Expressions

```ruby
puts `date`  # execute shell command
puts `pwd`
```

### Assignment Variations

```ruby
2 => x           # rightward assignment
a, b = 1, 2      # parallel assignment
a, b = b, a      # swap values
a = 1, 2, 3, 4   # a becomes array

a, *b = 1, 2, 3, 4, 5    # b gets [2,3,4,5]
a, *b, c = *(1..4)       # splat in middle
a, *, z = *("a".."z")    # first and last only

# Nested destructuring
a, (b, c), d = 1, [2, 3], 4
a, (b, *c), d = 1, [2, 3, 4], 5
```

### Conditionals and Boolean Logic

```ruby
puts false && 99   # => false
puts "" && 99      # => 99 (empty string is truthy)
puts false || 42   # => 42
puts 0 || 42       # => 0 (0 is truthy in Ruby!)

val ||= "default"  # assign if nil/false

puts !!"Ruby"      # => true (double negation for boolean)

puts defined? c    # check if defined
puts defined? Object
```

### Equality Methods

```ruby
puts (2 == 2.0)        # => true (value equality)
puts "a".eql?("a")     # => true (type and value)
puts "a".equal?("a")   # => false (object identity)
puts (0..10) === 7     # => true (case equality)
```

### Safe Navigation Operator

```ruby
data = {}
p data[:name]&.upcase  # => nil (no error)

data[:name] = "remy"
p data[:name]&.upcase  # => "REMY"
```

### Loops and Iterators

```ruby
a = 1
a *= 2 until a > 50
a -= 12 while a > 0

# Custom iterator class
class Eras
    def each
        yield "Meiji"
        yield "Taisho"
        yield "Showa"
    end
end

for era in Eras.new
    puts era
end
```

### Pattern Matching

```ruby
puts ("string" in String)
puts (3 in (1..5))
puts (["table", 8, "chair"] in [String, 1..10, /\w+/])
puts ({name: "Remy", nationality: "Japan"} in {nationality: String})
puts ([1, "Japan", 4, "Sushi", 8] in [*, "Japan", 4, *])

# Binding in patterns
[1, "potato", 2, "potato"] => [first, String, second, String]
p [first, second]

# Pin operator for matching values
def pick_a_card(cards)
    case cards
    in [*, {rank:}, {rank: ^rank}, *]
        "You have a pair of #{rank}s"
    else
        "You have no interesting cards"
    end
end
```

---

## inheritance_modules_mixins.rb

### Constant Scoping with Modules

```ruby
CONST = "outer scope"

module A
    CONST = "inner scope"
end

module A
    class B
        def self.const
            CONST  # => "inner scope"
        end
    end
end

class A::C
    def self.const
        CONST  # => "outer scope" (different lookup)
    end
end
```

---

## metaprogramming.rb

### Understanding Self

```ruby
puts self        # => main
puts self.class  # => Object

class Test
    puts self        # => Test
    puts self.class  # => Class
end
```

### Singleton Methods

Methods specific to particular objects:

```ruby
animal = "dog"

def animal.speak
    puts "The #{self} says woof!"
end

animal.speak
puts animal.singleton_class
puts animal.singleton_methods

# Alternative syntax
class << animal
    def type
       puts "#{self} is a canine"
    end
end
```

### Class Variable Accessor via Singleton Class

```ruby
class Test
    @var = 42

    class << self
        attr_accessor :var
    end
end

puts Test.var     # => 42
Test.var = 24
puts Test.var     # => 24
```

### Changing Visibility of Inherited Methods

```ruby
class User
    private
    def password
        "password123"
    end
end

class Admin < User
    public :password
end

Admin.new.password  # works!
```

### Module Inclusion and the Lookup Chain

```ruby
module Greeter
    def greet
        puts "Hello"
    end
end

class Example
    include Greeter
end

# Changes to module affect included classes
module Greeter
    def greet
        puts "こんにちは"
    end
end

Example.new.greet  # => "こんにちは"
```

### Prepend vs Include

```ruby
class Person
    prepend Greeter  # Greeter methods take precedence

    def greet
        puts "Hola!"
    end
end

Person.new.greet  # => "こんにちは" (from Greeter)
```

### Extending Individual Objects

```ruby
d1 = Doge.new
d1.extend(Greeter)
d1.greet  # works
d1.singleton_methods  # includes :greet
```

### Refinements for Local Changes

```ruby
module MyPrint
    refine Object do
        private def print(*args)
            args.each { |arg| Kernel.print("Remy says: #{arg}\n") }
        end
    end
end

class Person
    using MyPrint  # refinement only active here

    def message(msg)
        print(msg)
    end
end
```

### Class-Level Macros with define_method

```ruby
class Logger
    def self.add_logging(name)
        define_method(:log) do |msg|
            now = Time.now.strftime("%x")
            $stderr.puts("#{now}-#{public_send(name)}: #{self} #{msg}")
        end
    end
end

class Event < Logger
    attr_accessor :name
    add_logging :name  # the macro!
end
```

### Module with Metaprogramming Payload

```ruby
module AttrLogger
    def attr_logger(name)
        attr_reader name
        define_method("#{name}=") do |val|
            puts "Assigning #{val.inspect} to #{name}"
            instance_variable_set("@#{name}", val)
        end
    end
end

class Event
    extend AttrLogger
    attr_logger :value
end
```

### The Concern Pattern (self.included)

```ruby
module GeneralLogger
    def log(msg)
        puts "#{Time.now.strftime("%y-%m-%d")}-#{self.name}-#{msg}"
    end

    module ClassMethods
        def attr_logger(name)
            # class method implementation
        end
    end

    def self.included(host_class)
        host_class.extend(ClassMethods)
    end
end
```

### Structs and Data

```ruby
Dog = Struct.new(:name, :breed, :likes) do
    def to_s
        "#{name} is a #{breed} and likes #{likes}"
    end
end

lola = Dog.new("Lola", "Poodle", "Playing fetch")

# Immutable structs with Data.define
CustomerRecord = Data.define(:total_spend, :language)
customer1 = CustomerRecord.new(total_spend: 500, language: "Japanese")
customer2 = customer1.with(total_spend: 800)  # creates new instance
```

### Creating Classes Dynamically

```ruby
cuisine = Class.new(String) do
    def self.class_method
        puts "This is a class method"
    end

    def caps
        puts self.upcase
    end
end

japanese = cuisine.new("sushi")
japanese.caps  # => "SUSHI"
```

### instance_eval and class_eval

```ruby
"dog".instance_eval do
    puts self      # => "dog"
    puts upcase    # => "DOG"
end

Person.class_eval do
    def instance_method
        puts "Added via class_eval"
    end
end

Person.instance_eval do
    def class_method
        puts "This is a class method of #{self}"
    end
end
```

### Hook Methods

```ruby
# inherited hook
class Animal
    @children = []

    def self.inherited(child)
        @children << child
    end

    class << self
        attr_reader :children
    end
end

class Flamingo < Animal; end
class Parakeet < Animal; end

p Animal.children  # => [Flamingo, Parakeet]
```

### method_missing

```ruby
class Transportation
    UNDER_DEVELOPMENT = [:levitate]

    def method_missing(name, *args, &block)
        if UNDER_DEVELOPMENT.include?(name)
            puts "Method \"#{name}\" is under development!"
        else
            super
        end
    end

    def respond_to_missing?(name, include_private = false)
        UNDER_DEVELOPMENT.include?(name)
    end
end
```

---

## methods.rb

### Method Redefinition

```ruby
class Dog
    def speak
        puts "Woof!"
    end

    def speak  # redefines previous
        puts "Arf!"
    end
end
```

### Endless Method Definition

```ruby
def endless(arg) = puts arg
endless(42)

# Singleton endless method
lola = Dog.new
def lola.speak = puts "Mi!"
```

### Default Parameters with Expressions

```ruby
def surround(word, pad_with = word.length / 2)
    puts "#{'[' * pad_with}#{word}{']' * pad_with}"
end
```

### Rest Parameters

```ruby
def rest(num1, *rest)
    p "#{num1}, #{rest}"
end
rest(1, 2, 3, 4, 5)

def first_and_last(first, *, last)
    puts "First: #{first}, Last: #{last}"
end
```

### Keyword Arguments

```ruby
def shirt_sizes(**people)
    p people
end
shirt_sizes(Remy: "M", Nagahama: "L")

def address(city:, state:, zip:)
    "I live in #{city}, #{state}, #{zip}"
end
data = { city: "Burlington", state: "Vermont", zip: "05405" }
puts address(**data)  # splat hash into keyword args
```

### Forwarding Arguments (...)

```ruby
def do_something(...)
    other_method(...)
end
```

### Procs and Symbols as Blocks

```ruby
square = ->(n) { n * n }
p (1..5).map(&square)

p ("a".."f").to_a.map(&:upcase)
```

### Method Receiver as Expression

```ruby
def ("hello".class).last_upcase(str)
    str[0...-1] + str[-1].upcase
end

puts String.last_upcase("cat")  # => "caT"
```

### Nested Method Definitions

```ruby
def time
    def time
        def time
            "third time"
        end
        "second time"
    end
    "first time"
end

p time  # => "first time"
p time  # => "second time"
p time  # => "third time"
p time  # => "third time"
```

### Safe Navigation and Multiple Returns

```ruby
p nil&.upcase  # => nil (no error)

def method
    return "multiple", "values", "are", "returned"
end
p method  # => ["multiple", "values", "are", "returned"]
```

### Aliasing Methods

```ruby
class Integer
    alias minus -
end

p 5.minus(2)  # => 3
```

---

## numbers_strings_ranges.rb

### Number Literals

```ruby
puts 0x16       # hexadecimal => 22
puts 0xaabb     # hexadecimal
puts 0377       # octal
puts -0b10_1010 # binary with underscore separator
```

### Rational and Complex Numbers

```ruby
puts 3/4        # => 0 (integer division)
puts 3/4r       # => 3/4 (rational)
puts 0.25r      # => 1/4 (rational)
puts Rational(5, 7)
puts Complex(1, 2)
```

### Numeric Iteration

```ruby
100.downto(95) { |i| puts i }
0.step(20, 4) { |i| puts i }
puts 3.fdiv(4)  # float division
```

### String Interpolation and Concatenation

```ruby
def divide_by_two(num)
    num / 2.0
end

puts "Result: #{divide_by_two(25)}"
puts "This""is""one""string"  # adjacent strings concatenate
```

### String Literal Delimiters

```ruby
puts %q!now I can type '''''!   # single-quoted
puts %Q{now I can type """"}    # double-quoted
puts %(now I can type """" '''')
```

### Heredocs

```ruby
heredoc = <<END_OF_STRING
This is a heredocument,
which allows for strings
of multiple lines.
END_OF_STRING
```

### String Methods

```ruby
text = "Lorem ipsum dolor sit amet..."

puts text.gsub(/[aeiou]/, "!")
puts text.include?("ipsum")
puts text.end_with?(".")
puts text.empty?
puts text[0..3]
puts text.scan(/[a]/).length
text.each_char.with_index { |char, idx| puts char if idx < 10 }
puts text.count("i")
```

### Ranges

```ruby
range = (1..10)
arr = range.to_a

p arr[..2]              # first 3 elements
p range.include?(5)     # => true
p range.reject { |i| i > 5 }
p range === 7.2         # => true
p ('a'..'f').cover?('bbbb')  # => true
```

---

## object_model.rb

### The inherited Hook

```ruby
class Animal
    def self.inherited(subclass)
        puts "#{subclass} inherited #{self}"
    end
end

class Dog < Animal  # prints: "Dog inherited Animal"
end

class Cat < Animal  # prints: "Cat inherited Animal"
end
```

---

## reflections.rb

### ObjectSpace

```ruby
# Iterate over all objects of a type
ObjectSpace.each_object(Complex) { |object| puts object }

# Note: Immediate values (Symbol, true, false, nil, small integers)
# are not tracked by ObjectSpace
```

### Inspecting Objects

```ruby
arr = (1..10).to_a
puts arr.methods.count
puts arr.respond_to?(:each)

iterator = arr.method(:each)
iterator.call { |n| puts n }

puts a.object_id
puts a.kind_of?(Integer)   # includes superclasses
puts a.instance_of?(Integer)  # exact class only
```

### Inspecting Classes

```ruby
ObjectSpace.each_object(Class).with_index do |klass, index|
  p "Superclass: #{klass.superclass}"
  p "Subclasses: #{klass.subclasses}"
  p "Ancestors: #{klass.ancestors}"  # superclasses + mixins
end

# Class introspection
p Demo.public_instance_methods(false)
p Demo.singleton_methods(false)
p Demo.class_variables
p Demo.constants(false)
p demo.instance_variables
```

### Calling Methods Dynamically

```ruby
puts "lorem ipsum".public_send(:gsub, /[aeiou]/, "*")
```

### Method Objects

```ruby
user = { email: "example@gmail.com", age: 28 }
user_data = user.method(:values)
p user_data.call

# Using method objects like procs
method_object = method(:triple)
p (1..5).to_a.map(&method_object)
```

### Unbound Methods

```ruby
unbound_length = String.instance_method(:length)

class String
    def length
        99  # override
    end
end

p "cat".length  # => 99
p unbound_length.bind_call("cat")  # => 3 (original)
```

### eval and binding

```ruby
big_cat = "'cat'.upcase"
p eval(big_cat)  # => "CAT"

def get_binding
    cat = "CAT"
    binding
end

p eval("cat")              # uses current scope
p eval("cat", get_binding) # uses binding's scope
```

### Method Call Hooks with alias_method

```ruby
class Object
    alias_method :old_system, :system

    def system(*args)
        old_system(*args).tap do |result|
            puts "system(#{args.join(',')}) returned #{result.inspect}"
        end
    end
end
```

### Object Creation Hooks

```ruby
class Object
    attr_accessor :timestamp
end

class Class
    old_new = instance_method(:new)
    define_method(:new) do |*args, **kwargs, &block|
        result = old_new.bind_call(self, *args, **kwargs, &block)
        result.timestamp = Time.now.strftime("%L")
        result
    end
end
```

### Tracing Execution

```ruby
# TracePoint for debugging
TracePoint.trace(:line) { |tp| p tp }

# Call stack
def method_a
    puts caller
end

puts __callee__  # current method name
puts __FILE__    # current file
```

### The Ruby VM

```ruby
code = RubyVM::InstructionSequence.compile('a = 1')
puts code.disassemble
```

### Marshaling (Serialization)

```ruby
# Binary serialization
File.open("data", "w+") { |f| Marshal.dump(object, f) }
object = Marshal.load(File.open("data"))

# YAML serialization
class Serializer
    def encode_with(properties)
        properties["value"] = @value
    end
end

yaml_data = YAML.dump(obj)
obj = YAML.load(yaml_data, permitted_classes: [Serializer])

# JSON serialization
json_data = JSON.dump({ value: @value })
result = JSON.parse(json_data)
```

---

## regex.rb

### Basic Pattern Matching

```ruby
puts /cat/.match("catastrophe")   # returns MatchData
puts /cat/.match?("Cat")          # => false (case sensitive)
puts /cat/i.match?("Cat")         # => true (case insensitive)
```

### Substitution

```ruby
text = "A cat on a mat"
puts text.sub(/a/, "o")   # replace first
puts text.gsub(/a/, "o")  # replace all
```

### Pattern Creation

```ruby
pattern1 = /[aeiou]/
pattern2 = %r{mm/dd}
pattern3 = Regexp.new("www")

# Extended mode with comments
city_state_zip = %r{
    (\w+),      # City name
    \s
    ([A-Z]{2})  # State
    \s
    (\d{5})     # ZIP
}x
```

### MatchData Methods

```ruby
data = /[aeiou]/.match(text)
puts data.pre_match   # text before match
puts data[0]          # the match
puts data.post_match  # text after match
```

### Word Boundaries

```ruby
puts "six o'clock".gsub(/\b/, "*")  # word boundaries
puts "six o'clock".gsub(/\B/, "*")  # non-word boundaries
```

### Capture Groups

```ruby
time = /(\d\d):(\d\d)(..)/.match("12:50am")
puts time[0]  # => "12:50am" (full match)
puts time[1]  # => "12" (first group)
puts time[2]  # => "50" (second group)
puts time[3]  # => "am" (third group)

# Named captures
/(?<hours>\d\d):(\d\d)(..)/ =~ "12:50am"
puts hours  # => "12"
```

### Block Replacement

```ruby
puts "this is a string".gsub(/[aeiou]/) { |match| match.upcase }

def titlecaser(string)
    string.downcase.gsub(/\b\w/) { |first| first.upcase }
end

puts titlecaser("how to win friends")  # => "How To Win Friends"
```

### Backreferences

```ruby
puts "nercpyitno".gsub(/(.)(.)/,'\2\1')  # swap pairs
```

---

## ruby_style.rb

### Style Guides and Tools

- [Ruby Style Guide](https://rubystyle.guide/)
- [Shopify Ruby Style Guide](https://ruby-style-guide.shopify.dev/)
- **Standard**: A default RuboCop config (`gem standard`, run with `standardrb`)

### Duck Typing

Ruby uses duck typing: typing based on what messages an object responds to, not its class.

### to_s vs to_str

```ruby
# to_s: general string conversion
# to_str: strict string conversion
# If an object implements to_str, it can be used everywhere a string is expected
```

---

## syntax.rb

### Magic Comments

```ruby
# frozen_string_literal: true
# encoding: utf-8
# warn_indent: true
```

### Line Continuation

```ruby
# Expressions continue when ending with operator, comma, or open delimiter
a = (1 + 2
+ 3 + 4)

b = 5 + 6 \
+ 7 + 8    # backslash continuation

c = 4 + 5 +
6 + 7      # trailing operator continues
```

### Multi-line Comments

```ruby
=begin
Multi-line comment
block
=end
```

### Heredoc with Tilde

```ruby
puts <<~HERE.upcase
    indentation is stripped
    from the output
HERE

puts <<~HERE
Interpolation works: #{Time.now}
HERE
```

### String Encoding

```ruby
puts "cat".encoding.name   # => UTF-8
puts /cat/.encoding.name
puts :cat.encoding.name
```

### Symbol Literals

```ruby
puts :'a symbol with "quotes"'.class
puts :"symbol with #{substitution}".class
```

### Constant Scope

```ruby
OUTER_CONST = 41

class Calico
    CONST = OUTER_CONST + 1
end

puts Calico::CONST      # => 42
puts ::OUTER_CONST      # => 41 (top-level)
Calico::NEW_CONST = 100 # add constant from outside
```

### Class Variables (Shared Across Inheritance)

```ruby
class Object
    @@secret = "s3cr3t"
end

class String
    def self.get_secret
        @@secret  # accesses Object's class variable
    end
end
```

### Predefined Global Variables

```ruby
puts RUBY_RELEASE_DATE
puts RUBY_VERSION

`pwd`
puts $?  # exit status of last command
```

### Rightward Assignment and Pattern Matching

```ruby
3 => x  # rightward assignment

{a: "Hello", b: "World"} in {a:, b:}  # pattern matching
puts a, b

# Case equality
puts Class === String  # is String an instance of Class?
puts Array === []

case [1, 2, 3]
in [Integer, Integer => middle, Integer]
    puts "Middle: #{middle}"
end
```

---

## threads_fibers_ractors.rb

### Thread Basics

```ruby
require "net/http"

pages = ["www.figma.com", "www.react.dev", "www.google.com"]

threads = pages.map do |page|
    Thread.new(page) do |url|
        http = Net::HTTP.new(url, 80)
        print "Fetching: #{url}\n"
        response = http.get("/")
        print "Got #{url}: #{response.message}\n"
    end
end

threads.each { |thread| thread.join }  # wait for all threads
```

### Thread Safety and the GIL

- Global Interpreter Lock (GIL) ensures only one thread executes at a time
- Avoid shared mutable data between threads
- Use `Thread.join` and `Thread.value` for synchronization

### Mutex for Race Conditions

```ruby
mutex = Thread::Mutex.new
mutex.lock
mutex.unlock

mutex.synchronize do
    # automatically locks and unlocks
end
```

### Spawning External Processes

```ruby
spawn("date")        # asynchronous
system("git status") # synchronous
```

### Fibers

Lightweight coroutines that can be paused and resumed:

```ruby
words = Fiber.new do
    File.foreach("./testfile.txt") do |line|
        line.scan(/\w+/) do |word|
            Fiber.yield(word.downcase)
        end
    end
    nil
end

p words.resume  # get first word
p words.resume  # get second word

counts = Hash.new(0)
while (word = words.resume)
    counts[word] += 1
end
```

### Ractors (True Parallelism)

Each Ractor has its own GIL, enabling true parallel execution:

```ruby
counter = Ractor.new(name: "counter") do
    result = Hash.new(0)
    while (received_word = Ractor.receive)
        result[received_word] += 1
    end
    result
end

Ractor.new(counter, name: "reader") do |worker|
    File.foreach("./testfile.txt") do |line|
        line.scan(/\w+/) do |word|
            worker.send(word.downcase)
        end
    end
    worker.send(nil)  # signal done
end

counts = counter.take  # get result
```

Key Ractor concepts:
- Ractors are isolated (can't access external variables)
- Communication via `send` and `receive`
- Each Ractor is like a "room" with single entry/exit
