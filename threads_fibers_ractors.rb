# When a computer has more than one CPU, the program can split tasks across multiple CPUs
# Thread safety: each process will execute correctly no matter what order the threads operate
# Avoid data or status info shared between threads, esp. if that data is changeable by one threat without the other threads knowing
# Global Interpreter Lock (GIL) ensures Ruby only executes one threat at a time (ensures thread safety)

# The Thread class allows you to do two things at once

require "net/http"

pages = [
    "www.figma.com",
    "www.react.dev",
    "www.google.com"
]

p "Number of threads: #{Thread.list.count}"

# notice how the fetches for each page happens before any of the responses are displayed
threads = pages.map do |page|
    Thread.new(page) do |url|
        http = Net::HTTP.new(url, 80)
        print "Fetching: #{url}\n"
        response = http.get("/")
        print "Got #{url}: #{response.message}\n"
    end
end

p "Number of threads: #{Thread.list.count}"

# thread.join makes the main thread not exit until all the threads are executed
threads.each{ |thread| thread.join }

puts "The main thread reaches here only after all the threads we created has finished"

p "Number of threads: #{Thread.list.count} (timeout watchdog thread from net/http)"
p Thread.list.last.inspect

# Thread.join and Thread.value are the only low-level thread control methods we should use

# We can use Mutex to avoid race conditions (only one thread can access a resource at a time)
mutex = Thread::Mutex.new
mutex.lock
mutex.unlock
mutex.synchronize do
     # automatically locks and unlocks (even with exception while locked)
end

# Splitting tasks into several chunks (running multiple external processes)

spawn("date") #asynchronous
system("git status") #synchronous

# Fibers - blocks of code that can be stopped and restarted
# Unlike Threads, the code in the Fiber block is not immediately executed
# Fibers run until they hit Fiber.yield -> control yielded to main program -> main program runs #resume -> Fiber runs
# Lighter than threads (can spin up tens of thousands)

words = Fiber.new do
    File.foreach("./testfile.txt") do |line|
        line.scan(/\w+/) do |word|
            Fiber.yield(word.downcase)
        end
    end
    nil
end

p words

p words.resume

counts = Hash.new(0)
while(word = words.resume)
    counts[word] += 1
end

p counts.first(5).to_h

# Ractors - allow for true parallel processing within a single Ruby interpreter
# Each ractor maintains its own GIL
# "Room" with a single entry and a single exit
# Block passed to Ractor.new = inside of this "room"
# Each ractor is isolated, like a container (can't access external variables)
# Only way for value to be visible to a ractor is via #send

counter = Ractor.new(name: "counter") do
    result = Hash.new(0)
    while(received_word = Ractor.receive) # blocks here
        result[received_word] += 1
    end
    result
end

Ractor.new(counter, name: "reader") do |worker|
    File.foreach("./testfile.txt") do |line|
        line.scan(/\w+/) do |received_word|
            worker.send(received_word.downcase) # sends word to counter ractor
        end
    end
    worker.send(nil)
end

counts = counter.take # Get return of counter ractor
p counts.first(5).to_h