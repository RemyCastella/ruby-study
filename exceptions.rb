puts "Exception subclasses:", "\n" * 2
puts Exception.subclasses
puts "\n"
puts "Exception subclasses have their own subclasses. Eg. StandardError subclasses:", "\n" * 2
puts StandardError.subclasses

# StandardErrors and its subclasses are captured by regular Ruby processes
# Always subclass StandardError when making custom exceptions

class MissingUserError < StandardError
end

# Example error handling sequence

string =  "5 * 7"

begin
    result = eval string
rescue SyntaxError, NameError => e
    print "String doesn't compile:" + e
rescue StandardError => e
    print "Error running script:" + e
else
    puts result
ensure
    puts "I am always run"
end

# Raising exceptions

names = %w[Jon Marcus Maria Carl]
index = 5

if index >= names.count
    raise IndexError, "Index (#{index}) is too big", caller
else
    puts names[index]
end