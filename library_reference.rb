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

