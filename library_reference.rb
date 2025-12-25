# Object Model

class Animal
    def self.inherited(subclass)
        puts "#{subclass} inherited #{self}"
    end
end

class Dog < Animal
end

class Cat < Animal
end

you = Animal.new
p you.itself

# Enumerators/Containers

arr = (1..10).to_a
arr2 = [[[1,2]],3,4,5]
arr3 = [5,2,6,1,7,3,8,99]
arr4 = [5,2,7,4,3,7,8,9]

p arr.rotate
p arr.rotate(5)
p arr.rotate(-2)


p arr2.flatten
p arr2.flatten(1)

p arr2.join("|")

p arr.sample
p arr.shuffle

p arr <=> arr3
p arr4 <=> arr3
p arr3 - arr4
p arr2 * ","
p arr.intersection(arr2, arr3, arr4)
p arr.union(arr2, arr3, arr4)
p arr.bsearch{ |i| i > 5 } #binary search

# The Enumerable module looks for an each method in an including class for all of its functionality

class Students
    include Enumerable

    def initialize(*students)
        @students = students.flatten
    end

    def add_student(student)
        @student << student
    end

    def each
        @students.each do |student|
            yield student
        end
    end
end

my_students = Students.new("Tanaka", "Nishiyama", "Yamamoto", "Takashima")

p my_students.map{ |student| student.upcase } #alias collect
my_students.cycle(3){ |student| print "#{student}\n" }
my_students.reverse_each{ |student| p student }
my_students.each_with_index{ |student, index| puts "#{index + 1}. #{student}"}
p my_students.take(2)
p my_students.drop(2)
p my_students.take_while{|student| student.match?(/t/i)}
p my_students.drop_while{|student| student.match?(/t/i)}
p my_students.group_by{ |student| student[0]}
p my_students.zip([1,2,3,4])
p my_students.find{|student| student.start_with?("T")} #alias detect
p my_students.select{|student| student.start_with?("T")} #alias find_all, filter
p my_students.grep("Tanaka"){|student| student.downcase}
p my_students.count{|student| student.start_with?("T")}
p my_students.include?("Sahara")
p my_students.any?{|student| student.start_with?("N")}
p my_students.all?{|student| student.length > 3}
p my_students.sort_by(&:length)

p my_students
arr = (1..10).to_a
p arr.each_slice(3).map{|slice| slice }.length
p arr.each_cons(3).map{|slice| slice }.length
p arr.reduce(100, :+) #alias inject
p arr.partition{|num| num.odd?}
p arr.slice_after{ |n| n.even? }.to_a
p arr.slice_before{ |n| n.even? }.to_a


h = Hash.new{|hash, key| hash[key] = []} #cannot use [] as default value (Hash.new([]) as same array will be used for each key)
h[:a] << "Tanaka"
h[:b] << "Sato"
p h

p h.default_proc
p h.default

p h.fetch(:f, default_value = [])
h[:f] << "Azegami"
p h.fetch(:f, default_value = [])
p h.values_at(:a, :b)
p h.dig(:a, 0)
p h.merge({z: ["Iino"]})
p h.values.flatten
p h.invert
p h.transform_values{|val| val.map(&:upcase) }
h.clear
p h

s1 = [1, 1, 2, 2, 3, 4, 5, 6, 6, 7, 7, 8, 9, 9, 9].to_set
p s1
raw_data = [1,1,1,1,"two","two",2,2,4,4,4,5, "five", "five", "five"]
s2 = Set.new(raw_data)
s3 = Set[1,2,3]
p s2
p s1.merge(s2)
p s3 < s1
p s1 === 4

# IO, Files, Formats

require 'csv'
    #methods include parse, open, foreach, read, etc.

CSV.foreach("#{__dir__}/data.csv", headers: true) do |row|
    puts row["Username"]
end

dir = Dir.new("#{__dir__}")
p dir
Dir.open("#{__dir__}"){ |dir| p dir }
p dir.select{ |file| !file.end_with?(".rb") }
p Dir.glob("./*.md")
p Dir.pwd
    #destructive methods include: Dir.rmdir, Dir.delete, Dir.unlink

file = File.new("testfile.txt", "a+")
file.chmod(0644)
file.chown(501, 20)
p File.basename("testfile")
p File.dirname("testfile")
p File.birthtime("testfile.txt")
p File.atime("testfile.txt")
p File.exist?("testfile.txt")
File.delete("testfile.txt")

# know the difference between `date`, system("date"), and IO.popen("date")
result = IO.popen("date")
p result.read

date = IO.popen("date")
string_file = StringIO.new(date.read)
p string_file.read
string_file.rewind
p string_file.read


require 'json'

data = {
    username: "coolUser12",
    email: "email@gmail.com",
    friends: ["Jason", "John", "James"]
}

p json = JSON.generate(data) #data.to_json also works
p JSON.parse(json, symbolize_names: true)


require 'uri'

uri = URI.parse("https://9gag.com/trending")
p uri.scheme
p uri.host
p uri.port
p uri.path

require 'yaml'
yaml = YAML.dump(data)
puts yaml

require 'benchmark'

str = "Hello, this is a string!"

Benchmark.bm(10) do |x|
    x.report("direct"){10_000.times{str.length}}
    x.report("send"){10_000.times{str.send(:length)}}
    x.report("eval"){10_000.times{eval("str.length")}}
end


require 'singleton'

class A
    attr_accessor :data
    include Singleton
end

# a = A.new // new becomes private method
# clone, dupe, etc. are also overwritten
# instance returns a singleton instance

a = A.instance
b = A.instance
a.data = 42

p a.object_id
p b.object_id
p a.data
p b.data



