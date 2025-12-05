# frozen_string_literal: true
# encoding: utf-8
# warn_indent: true
# ↑ these are magic comment directives

# Ruby expressions and statements are terminated at the end of a line
# except when it ends with an operator, comma, or open delimiter

a = (1 + 2
+ 3 + 4)

b = 5 + 6 \
+ 7 + 8

c = 4 + 5 +
6 + 7

p [a, b, c]

=begin
we can write
multi-line comment
like this
=end

# strings

puts <<~HERE.upcase
    we can indent strings
    and add line breaks
    because our heredoc has
    a tilde

HERE

puts <<~HERE
We can also call methods
inside heredocs (#{Time.now})
HERE

str = 'adj'"acent"
puts str

3.times do 
    puts "Hello".object_id # This will print the same number because we have frozen_string_literal: true
end

puts "cat".encoding.name
puts /cat/.encoding.name
puts :cat.encoding.name

# symbols

substitution = "substitution"

puts :'a symbol can have "quotes"'.class
puts :"a symbol can also have #{substitution}".class

# Scope of constants and variables

OUTER_CONST = 41

class Calico
    CONST = OUTER_CONST + 1

    def get_const
        CONST
    end
end


cat = Calico.new

puts cat.get_const
puts Calico::CONST
puts ::OUTER_CONST

Calico::NEW_CONST = 100

puts Calico::NEW_CONST

# Class variables are inherited, and all point to the same value
# thus, they can lead to confusion (better to avoid)

class Object
    @@secret_variable = "s3cr3t"
end

class String
    def self.get_secret
        @@secret_variable
    end

    def self.change_secret
        @@secret_variable = "5ecre7"
    end
end

puts String.get_secret
String.change_secret
puts String.get_secret

# while, until, for loops aren't blocks so they can access/create local variables

i = 0
while(i < 1)
    new_variable = "Hello!"
    i += 1
end

puts new_variable

# predefined values (there are many more!)

puts RUBY_RELEASE_DATE
puts RUBY_VERSION

`pwd`

puts $? #stores the exit status of the above pwd command

# assignment

3 => x #rightward assignment
puts x

{a: "Hello", b: "World"} in {a:, b:} #pattern matching
puts a, b


# pattern matching

puts Class === String #is String an instance of Class?
puts String === Class
puts Array === []

case [1,2,3]
in [Integer, Integer => middle, Integer] #we can bind a sub-pattern to a local variable
    puts "Middle integer: #{middle}"
else
    puts "No integers"
end