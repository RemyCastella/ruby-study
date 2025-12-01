# Metaprogramming = writing code that writes code
# Basically, it's creating your own DSL

# "Understanding self is the key to Ruby, and the key to life"

puts self
puts self.class

class Test
    puts self
    puts self.class
end

puts self

# Singleton methods - methods specific to particular objects

animal = "dog"

def animal.speak
    puts "The #{self} says woof!"
end

animal.speak

puts animal.class
puts animal.singleton_class
puts animal.singleton_methods

# You can also access singleton class using: class << obj

class << animal
    def type
       puts "#{self} is a canine"
    end
end

animal.type

singleton = class << animal
    self
end

puts singleton

# Creating an accessor for class variables via its singleton class

class Test
    @var = 42

    class << self
        attr_accessor :var
    end
end

puts Test.var
puts Test.var = 24
puts Test.var

# Changing the visibility of a superclass
# This is done via super, which can call private methods


class User
    private

    def password
        "password123"
    end
end

class Admin < User
    public :password
end

admin = Admin.new

puts admin.password

# When you include a module, an anonymous superclass that references the module is created
# This way, a module can be included in many classes while maintaining the lookup chain for each class
# This also means when you change the module after inclusion, the included behavior changes

module Greeter
    def greet
        puts "Hello"
    end
end

class Example
    include Greeter
end

e = Example.new
e.greet

module Greeter
    def greet
        puts "こんにちは"
    end
end

e.greet

class Person
    prepend Greeter

    def greet
        puts "Hola!"
    end
end

p = Person.new
p.greet

# Extending individual objects

class Doge
    def method_missing(method_name)
        puts "#{method_name} does not exist in #{self.class}!"
    end
end

d1 = Doge.new
d2 = Doge.new
d1.extend(Greeter)
d1.greet
puts d1.singleton_methods
puts d1.singleton_class
d2.greet
puts d2.singleton_methods

