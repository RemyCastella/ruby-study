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

# This adds class methods because extend adds to self

class Person
    extend Greeter
end

Person.greet

# Any changes we make with prepend and monkey patches are global
# The changes also affect the libraries and gems we use!
# Refinements allow for local changes to classes (but they are rarely used)


module MyPrint
    refine Object do
        private def print(*args)
            args.each do |arg|
                Kernel.print("Remy says: #{arg}\n")
            end
        end
    end
end

class Person
    using MyPrint

    def initialize(name)
        @name = name
    end

    def message(msg)
        print(msg)
    end
end


p.message("Nice to meet you!")

# Class-level macros

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
    add_logging :name # this is the class-level macro!
    
    def initialize(name)
        @name = name
    end
    
end

umf = Event.new("Ultra Music Festival")

umf.log("Registration has begun.")
umf.log("Tickets have sold out!")

# Other interesting metaprogramming methods include:
# send, instance_variable_set, instance_variable_get, class_eval, instance_eval, etc.

# We can also use a module to hold metaprogramming payload

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

umf.value = "Fun"
puts "The value of #{umf.name} is #{umf.value}"

# extend class if self.included? (Including instance and class methods together)
# The Concern pattern (Rails)

module GeneralLogger
    puts "self = #{self}"
    def log(msg) # will be added as an instance method
        puts "self = #{self}"
        puts "#{Time.now.strftime("%y-%m-%d")}-#{self.name}-#{msg}"
    end

    module ClassMethods # will be added as class methods
        puts "self = #{self}"
        def attr_logger(name)
            attr_reader name

            define_method("#{name}=") do |val|
                log("Assigning #{val.inspect} to #{name}")
                instance_variable_set("@#{name}", val)
            end
        end
    end

    def self.included(host_class)
        puts "#{host_class} just hosted #{self}"
        host_class.extend(ClassMethods)
    end
end

class Person
    puts "self = #{self}"
    include GeneralLogger #first puts message

    attr_logger :name
end

james = Person.new("James")
james.log("New person created") #instance method
puts james.name
james.name = "Jim" #comes from the attr_logger class method
puts james.name

# Structs and sub-classing

Dog = Struct.new(:name, :breed, :likes) do
    def to_s
        "#{name} is a #{breed} and likes #{likes}"
    end
end

lola = Dog.new("Lola", "Poodle", "Playing fetch")
p lola
puts lola

