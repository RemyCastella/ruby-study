# Dates and times

Time # represents moment in time that includes both date and time

# only date (no time), must be required
# Date

# deprecated, only for dates in the distant past, must be required
# DateTime 

time = Time.now

puts time.year, time.month, time.day, time.sec, time.subsec

puts time.nsec, time.usec # returns subseconds in nano and microseconds

puts time.wednesday?

days_left = 365 - time.yday

puts time.yday, days_left

puts time + 3600 #3600 seconds = 60 minutes = 1 hour

puts time.to_f, time.to_i, time.to_r # seconds since Unix Epoch date

puts 6.div(2) #vs
puts 6.fdiv(2)

puts 4.lcm(30)
puts 111.gcd(12)

# Strings

str = "This is an example sentence"
puts str.count("s")
puts str.count("sa")
puts str.count("a-f")
puts str.count("^A-Ra-r ")

puts str.index(/[a-z]/)
puts str.index("e")
puts str.index("e", 11)
puts str.index("e", -6)

puts str.rindex("e")
puts str.rindex("e", 12)
puts str.rindex("e", -11)

puts str.include?("f")
puts str.match?(/[A-Z]/)

puts str.start_with?("T")
puts str.end_with?("w")

puts str[1..3]
puts str[1,5]
puts str.slice(1..3)
puts str.slice(1,5)

str2 = "This is \r\n" #\r\n are windows end of line markers

puts str.chop
puts str2.chop.size

str2.each_char{ |c| c.upcase }
str2.each_byte{ |b| p b }
str2.each_codepoint{ |c| p c }
str2.each_grapheme_cluster{ |g| p g }

p str.scan(/\s.{1}/)
p str.split

p str.partition("s")
p str.rpartition("s")

p str.insert(8, "just ")

p str.delete("i")

p str.gsub(/[aeiou]/, "*")

p str.tr("aeiou", "$")

p "hellllllo".squeeze("l")

p "div".ljust(8)
p "div".center(8)
p "div".rjust(8)
p "div".center(8, "-")

p str.swapcase

p str2.reverse

p :symbol.upcase


