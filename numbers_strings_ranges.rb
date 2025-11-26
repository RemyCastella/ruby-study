# Numbers
puts 0x16
puts 0xf
puts 0xaabb
puts 0377
puts -0b10_1010
puts 3/4
puts 3/4r
puts 0.25r
puts Rational(5,7)
puts Complex(1, 2)
puts "3" + "4"
puts 3.fdiv(4)
100.downto(95){ |i| puts i }
0.step(20, 4){ |i| puts i }

# Strings
# Probably the largest Ruby class with over 100 standard methods

def divide_by_two(num)
    num / 2.0
end

puts "Let's divide by two! 25/2 = #{divide_by_two(25)}"
puts "This""is""just""one""string"
puts %q!now I can type '''''!
puts %Q{now I can type """"}
puts %(now I can type """" '''')

heredoc = <<END_OF_STRING
This is a heredocument,
which allows for strings
of muliple lines. You can 
add a - of ~ symbol to modify
the heredoc as well!
END_OF_STRING
puts heredoc

text = "Lorem ipsum dolor sit amet consectetur adipisicing elit. Sapiente atque officia assumenda sequi quidem qui, sed provident mollitia similique suscipit!"

puts text.gsub(/[aeiou]/, "!")
puts text.include?("ipsum")
puts text.end_with?(".")
puts text.empty?
puts text[0..3]
puts text.scan(/[a]/).length
text.each_char.with_index{ |char, idx| puts char if idx < 10 }
puts text.count("i")

# Ranges

range = (1..10)
arr = range.to_a

p arr[..2]
p range.include?(5)
p range.reject{ |i| i > 5 }
p range === 7.2
p ('a'..'f').cover?('bbbb')