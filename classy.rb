# => RB120 Object Oriented Programming
# => Lesson 1 OOP book Exercises
# => Febuary 6-?, 2019
# => David George 
# => dmg2go@gmail.com
# => classy.rb


require 'securerandom'
require 'pry'

class Plant

  def initialize(name)
    self.name = name
    @entry_id = get_uuid
    @entry_date = Time.now
  end

def get_uuid
  SecureRandom.uuid
end

def to_s
    super + "=> name: #{name}. entry_id: #{@entry_id} entered: #{@entry_date}"
  end
end

class Veg < Plant

  attr_accessor :name, :cals, :grams
  attr_reader :entry_id

  def initialize(name, cals, portion)
    super(name)
    self.cals = cals
    self.grams = portion
  end

  def to_s
    super + "=> cals: #{cals}. portion: #{grams}"
  end
end




olive = Veg.new("olive", "330", "100g")

p olive.to_s
