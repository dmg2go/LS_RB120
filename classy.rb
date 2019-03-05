# => RB120 Object Oriented Programming
# => Lesson 1 OOP book Exercises
# => Febuary 6-?, 2019
# => David George
# => dmg2go@gmail.com
# => classy.rb

require 'securerandom'
require 'pry'

module Cookable
  attr_reader :fave_recipe
  attr_reader :season

  def add_recipe(recipe)
    @fave_recipe = recipe
  end

  def remove_recipe
    @fave_recipe = nil
  end

  def show_recipe
    @fave_recipe
  end

  def in_season?
    season
  end
end

class Plant
  @@object_count = 0
  def initialize(name)
    self.name = name
    @entry_id = get_uuid
    @entry_date = Time.now
    @@object_count += 1
  end

  def uuid
    SecureRandom.uuid
  end

  def to_s
    super + "=> name: #{name}. entry_id: #{@entry_id} entered: #{@entry_date}"
  end

  def self.how_many_plant_objects?
    puts "#{@@object_count} plant objects have been instantiated."
  end
end

class Veg < Plant
  EDIBLE = true
  include Cookable
  attr_accessor :name, :cals, :grams

  def initialize(name, cals, portion)
    super(name)
    self.cals = cals
    self.grams = portion
  end

  def to_s
    super + "=> cals: #{cals}. portion: #{grams}"
  end

  def edible?
    EDIBLE
  end
end

class Tree < Plant
  EDIBLE = false
  DENSITY_TABLE = { "maple" => 650, "aspen" => 420 }
  attr_accessor :name, :height, :specie
  def initialize(name, height, specie)
    super(name)
    self.height = height
    self.specie = specie
  end

  def to_s
    super + "=> height: #{height}"
  end

  def selfie
    puts object_id
  end

  def edible?
    EDIBLE
  end

  def how_heavy?
    density
  end

  private

  def density(volume = 1, moisture_content = 0.06)
    # binding.pry
    density = lookup(specie) * volume * moisture_content
    puts "#{specie} density is #{density} kg/m**3 (assume moisture of 6%)."
  end

  def lookup(specie)
    a_tree = DENSITY_TABLE.fetch(specie, "maple")
    # binding.pry
    a_tree
  end
end

olive = Veg.new("olive", "330", "100g")
# p olive.to_s
p olive.edible?
Plant.how_many_plant_objects?
puts olive.show_recipe
olive.add_recipe("chop and pan fry with anchovies")
puts olive.show_recipe

maple = Tree.new("maple", "100 ft", "maple")
# p maple.to_s
p maple.edible?
Plant.how_many_plant_objects?

# p Veg.ancestors

maple.how_heavy?

aspen = Tree.new("aspen", "90 ft", "aspen")
Plant.how_many_plant_objects?

aspen.how_heavy?

puts aspen.object_id

aspen.selfie
