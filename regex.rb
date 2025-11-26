puts /cat/.match("catastrophe")
puts /cat/.match?("Cat")
puts /cat/i.match?("Cat")


text = "A cat on a mat"
puts text.sub(/a/, "o")
puts text.gsub(/a/, "o")

pattern1 = /[aeiou]/
pattern2 = %r{mm/dd}
pattern3 = Regexp.new("www")
city_state_zip = %r{
    (\w+), # City name followed by a comma
    \s
    ([A-Z][A-Z])
    \s
    (\d{5})
}x # The x flag tells ruby to ignore whitespaces and comments

puts pattern1.match?("car")
puts "yyyy/mm/dd".match?(pattern2)
puts "www.google.com".match?(pattern3)
puts city_state_zip.match?("Chicago, IL 60601")

data = pattern1.match(text)
p data
puts data.pre_match
puts data[0]
puts data.post_match
puts "six o'clock".gsub(/\b/, "*")
puts "six o'clock".gsub(/\B/, "*")
puts "red ball blue sky".match(/red ball|square/)

time = /(\d\d):(\d\d)(..)/.match("12:50am")
puts time[0]
puts time[1]
puts time[2]
puts time[3]

time = /(?<hours>\d\d):(\d\d)(..)/ =~ "12:50am"
puts hours

puts "this is a string".gsub(/[aeiou]/){ |match| match.upcase }

def titlecaser(string)
    string.downcase.gsub(/\b\w/){ |first| first.upcase }
end

puts titlecaser("how to win friends and influence people")

puts "nercpyitno".gsub(/(.)(.)/,'\2\1')