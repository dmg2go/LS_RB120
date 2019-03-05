# => RB120 Object Oriented Programming
# => Lesson 2 Classes & Objects Exercises
# => Febuary 17, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn2_polymorphism_encapsulation.rb
require 'pry'

# => 1.

class Animal
  def eat
    # generic eat method
  end
end

class Fish < Animal
  def eat
    # eating specific to fish
  end
end

class Cat < Animal
  def eat
     # eat implementation for cat
  end
end

def feed_animal(animal)
  animal.eat
end

array_of_animals = [Animal.new, Fish.new, Cat.new]
array_of_animals.each do |animal|
  feed_animal(animal)
end