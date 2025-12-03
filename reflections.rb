# Programs can discover the following information about itself:
# What objects it contains, its class hierarchy, attributes/methods of objects, information on methods
# ObjectSpace - let's you see objects that have been created and not yet destroyed by garbage collection

# ObjectSpace.each_object{ |object| puts object } <= This results in a huge list
# We can specify the type of objects

a = Complex(1, 2)
ObjectSpace.each_object(Complex){ |object| puts object }

# 42 doesn't show up because ObjectSpace does not know about objects with immediate values
# Immediate values = values small enough not to be stored separately in memory (Symbol, true, false, nil, small integers and floats)
a = 42
b = 421234123412341212341234123412341235154
ObjectSpace.each_object(Integer){ |object| puts object}

# Looking at objects

arr = (1..10).to_a
methods = arr.methods
puts methods.count

puts arr.respond_to?(:each)
puts arr.respond_to?(:upcase)

iterator = arr.method(:each)
iterator.call{ |n| puts n }

puts a.object_id
puts a.kind_of?(Integer)
puts a.kind_of?(Numeric)
puts a.instance_of?(Integer)
puts a.instance_of?(Numeric)

# Looking at classes

ObjectSpace.each_object(Class).with_index do |klass, index|
  break if index > 3 # only look at the first 4 classes
  p "Superclass of #{klass}: #{klass.superclass}"
  p "Subclasses of #{klass}: #{klass.subclasses}"
  p "Ancestors of #{klass}: #{klass.ancestors}" #lists all superclasses and mixed-in modules
  puts ""
end

class Demo
    @@var = Time.now.strftime("%Y")
    CONST = 42

    def self.class_method
        "I am a class method"
    end

    def public_method
        x = 10
        y = 11
        local_variables
    end

    protected

    def protected_method
        "I am protected"
    end

    private

    def private_method
        "I am private"
    end
end

demo = Demo.new

#false means don't look at superclasses
#same method exists for protected and private instance methods
p Demo.public_instance_methods(false) 
p Demo.singleton_methods(false)
p Demo.class_variables
p Demo.constants(false)
p demo.instance_variables
p demo.public_method #runs public_method and returns local_variables

# Calling methods dynamically

puts "lorem ipsum".public_send(:gsub, /[aeiou]/, "*")

# method objects

user = {
    email: "example@gmail.com",
    age: 28
}

user_data = user.method(:values)
p user_data.call

def triple(a)
    3 * a
end

method_object = method(:triple)

p (1..5).to_a.map(&method_object) # we can use method objects as we would procs

# method objects are always bound to an object (eg. user)

# There are also unbound methods, created by calling instance_method on a class

unbound_length = String.instance_method(:length)
p unbound_length.class

class String
    def length
        99
    end
end

p "cat".length
p unbound_length.bind_call("cat") #we can bind and call unbound methods to specific objects

# eval parses and executes a string of legal Ruby code

big_cat = "'cat'.upcase"
p eval(big_cat)

# binding returns the current context, which can include local and other variables, etc.

cat = "cat"

def get_binding
    cat = "CAT"
    binding
end

p get_binding

p eval("cat")
p eval("cat", get_binding)

# eval is much slower than #public_send and Method#call

# method call hooks

class Object
    alias_method :old_system, :system

    def system(*args)
        old_system(*args).tap do |result|
            puts "system(#{args.join(',')}) returned #{result.inspect}"
        end
    end
end

system("pwd")

# we can also do something similar with prepend

module SystemHook
    private def system(*args)
        super.tap do |result|
            puts "system(#{args.join(',')}) returned #{result.inspect}"
        end
    end
end

class Object
    prepend SystemHook
end

system("date") # puts will run twice because of the alias we created in Object

# object creation hooks - allows you to wrap objects, add/remove methods from objects, etc. when they are created

# simple example of creating a timestamp for every object

class Object
    attr_accessor :timestamp
end

class Class #every class we create is an instance of class Class
    old_new = instance_method(:new) # this is the old Class.new
    define_method(:new) do |*args, **kwargs, &block| # we redefine Class.new, allowing positional args, keyword args, and blocks
        result = old_new.bind_call(self, *args, **kwargs, &block) # we run the old Class.new and store it in result
        result.timestamp = Time.now.strftime("%L") unless result.is_a?(Time) # we add the timestamp attribute
        result
    end
end

class Test
end

obj1 = Test.new
sleep(0.001)
obj2 = Test.new

p obj1.timestamp
p obj2.timestamp

# Tracing our program's execution

# TracePoint allows you to see the interpreter as it executes your code

# TracePoint.trace(:line) do |trace_point|
#     p trace_point
# end <= don't run this because the output is crazy

# Kernel#caller returns an array of strings representing the current call stack

def method_a
    puts caller
end

def method_b
    method_a
end

def method_c
    puts __callee__
    method_b
end

method_c