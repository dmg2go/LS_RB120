# => RB120 Object Oriented Programming
# => Lesson 1 OOP book Exercises
# => Febuary 6-?, 2019
# => David George 
# => dmg2go@gmail.com



class MyClass
  def initialize(name)
    @name = name
    
  end

  def rep
    puts "ancestors "# << self.ancestors
  end
end

p MyClass.ancestors


a_class = MyClass.new("xyz")

p a_class.rep
p a_class.ancestors