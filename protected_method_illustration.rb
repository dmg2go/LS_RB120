# => RB120 Object Oriented Programming
# => Lesson 1 OOP book Exercises
# => Febuary 12, 2019
# => David George 
# => dmg2go@gmail.com
# => my_student.rb

require 'pry'


class Student
  attr_writer :grade
  attr_accessor :name

  def initialize(grade, name)
    self.name = name
    self.grade = grade
  end

  def better_grade_than?(other_student)
    self.whats_my_grade? > other_student.whats_my_grade?
  end

  protected

  def whats_my_grade?
    @grade
  end
end

stan = Student.new(77, "stan")
jim = Student.new(88, "jim")

puts "Well done!" if jim.better_grade_than?(stan)


class Animal
  def a_public_method
    "Will this work? " + self.a_protected_method
  end

  protected

  def a_protected_method
    puts "Yes, in a I'm protected!"
    "a object protected method block - hi"
  end

  def some_other_method
    puts "howdy!"
  end
end

class Stump

  def a_public_method(x)
    "Will Stump work? " + self.b_protected_method(x)
  end

  protected
  def b_protected_method(x)
    #binding.pry
    puts "Yes, in b and I'm protected!"
    x.a_public_method
  end
end

a = Animal.new
a.a_public_method
#
puts a.protected_methods

b = Stump.new
b.a_public_method(a)
