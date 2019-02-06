
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
  attr_accessor :name, :breed, :age, :weight

  def initialize(n, b, a, w)
    self.name = n
    self.breed = b
    self.age = a
    self.weight = w
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

sparky = GoodDog.new("Shizz", "Beagle", 3, 12)

p GoodDog.ancestors
p sparky.class
p sparky.speak
p sparky.info
sparky.name = "Jingles"
p sparky.speak
sparky.state_update("Alphonse", "mutt", 8, 25)

p sparky.info