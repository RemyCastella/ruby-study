# I/O related methods are implemented in the Kernel module (gets, open, print, puts, readline, etc.)
# These methods are available to all objects
# Ruby also has a dedicated IO classes
# I/O is a bidirectional channel between a Ruby program and external resources

p "Ancestors:", IO.ancestors
p "Subclasses:", IO.subclasses

file = File.new("file_name", "w") # You can't create a new file with "r" mode!
p file
file.close

# Know these common file modes
file_modes = ["r", "w", "a", "r+", "w+", "a+"]

File.open("testfile.txt", "w+") do |file|
    file.write "Hello!"
    file.each_byte #...
    file.each_line #...
end # file is always closed

File.foreach("testfile.txt"){ |line| puts line }

str = IO.read("testfile.txt")
p str
arr = IO.readlines("testfile.txt")
p arr

puts File.realpath("testfile.txt")

$stdout << 99 << " red balloons" << "\n"

# Know about the open-uri library too

require "open-uri"

url = "https://www.ruby-dev.jp/"

URI.open(url) do |f|
    puts f.read.scan(/<h1 class=".*?">.*?<\/h1>/m).uniq
end