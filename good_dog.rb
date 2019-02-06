# => RB120 Object Oriented Programming
# => Lesson 1 OOP book Exercises
# => Febuary 6-?, 2019
# => David George 
# => dmg2go@gmail.com
# good_dog.rb
=begin
class GoodDog
  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} sez Arf!"
  end

  def name
    @name
  end

  def name=(n)
    @name = n
  end
end

sparky = GoodDog.new("Shizz")

p GoodDog.ancestors
p sparky.class
p sparky.speak
p sparky.name
sparky.name = "Jingles"
p sparky.speak
=end

class GoodDog
  
  @@instance_count = 0

  attr_accessor :name, :breed, :age, :weight

  def initialize(n, b, a, w)
    self.name = n
    self.breed = b
    self.age = a
    self.weight = w
    @@instance_count += 1
  end

  def self.instance_count
    @@instance_count
  end

  def state_update(n, b, a, w)
    self.name = n
    self.breed = b
    self.age = a
    self.weight = w
  end

  def info
    "#{name} weighs #{weight}, is a #{age} year old #{breed}."
  end

  def speak
    "#{name} sez Arf!"  # calling the attr_accessor method rather than reference to @var
  end
end

shizz = GoodDog.new("Shizz", "Beagle", 3, 12)

bomber = GoodDog.new("Bomber", "hound", 6, 42)

p shizz.info

p shizz.speak
shizz.state_update("Alphonse", "mutt", 8, 25)

p bomber.info

p "There are  #{GoodDog.instance_count} GoodDog instances."

p shizz.info

puts shizz
p shizz
puts bomber
p bomber