# => RB120 Object Oriented Programming
# => Lesson 1 OOP book Exercises
# => Febuary 6-?, 2019
# => David George 
# => dmg2go@gmail.com
# => my_car.rb

require 'pry'

class MyCar
  attr_accessor :color, :year, :make, :model
  attr_reader :speed, :is_running
  
  def initialize(ma, mo, yr, col)
    self.model = mo
    self.make = ma
    self.year = yr
    self.color = col
    @speed = 0
    @is_running = false
  end

  def start_motor
    @is_running = true
  end

  def stop_motor
    @is_running = false
  end

  def accelerate(how_much)
    if @is_running == true
      @speed += how_much
    else
      puts "start the car first"
    end
  end

  def decelerate(how_much)
    if @speed < how_much
      @speed = 0
    else 
      @speed -= how_much
    end
  end
end


a_car = MyCar.new("Ford", "Mustang", 1999, "red")

a_car.accelerate(25)
p a_car.speed
a_car.start_motor
a_car.accelerate(25)
p a_car.speed
