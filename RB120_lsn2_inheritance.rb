# => RB120 Object Oriented Programming
# => Lesson 2 Classes & Objects Exercises
# => Febuary 17, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn2_inheritance.rb
require 'pry'

# => 1.
=begin
class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"


class BullDog < Dog
  def swim
    "can't swim"
  end
end

butch = BullDog.new
puts butch.speak
puts butch.swim

=end

puts "\n *********************************\n1\n2"

# => 2.

class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def speak(sound_string)
    puts "#{sound_string}"
  end
end




class Dog < Animal
  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end


class BullDog < Dog
  def swim
    "can't swim"
  end
end

class Cat < Animal
  def hiss
    puts "hissss!"
  end
end


butch = BullDog.new
butch.speak('yap')
puts butch.swim

fido = Dog.new
puts fido.speak("growlf!")

socks = Cat.new
socks.hiss
socks. speak("meow")

puts Cat.ancestors
