# => RB120 Object Oriented Programming
# => Lesson 2 Classes & Objects Exercises
# => Febuary 17, 2019
# => David George 
# => dmg2go@gmail.com
# => RB120_lsn2_classes_objects.rb

require 'pry'

# => 1.
class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new('bob')
puts bob.name                  # => 'bob'
bob.name = 'Robert'
puts bob.name                  # => 'Robert'
puts "\n *********************************\n1\n2"

# => 2.
class Person
  attr_accessor :first_name, :last_name
  def initialize(fn = '', ln = '')
    @first_name = fn
    @last_name = ln
  end

  def name
    "#{@first_name} #{@last_name}"
  end
end

bob = Person.new('Robert')

puts bob.name                  # => 'Robert'
puts bob.first_name                  # => 'Robert'
puts bob.last_name                  # => ''
bob.last_name = 'Smith'
puts bob.name                  # => 'Robert Smith'

puts "\n *********************************\n1\n2"

# => 3.

class Person
  attr_accessor :first_name, :last_name, :name
  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  private

  def parse_full_name(full_name)
    name_parts = full_name.split
    self.first_name = name_parts.first
    self.last_name = name_parts.count > 1 ? name_parts.last : ''
  end
end

bob = Person.new('Robert')
puts bob.name                  # => 'Robert'
puts bob.first_name            # => 'Robert'
puts bob.last_name             # => ''
bob.last_name = 'Smith'
puts bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
puts bob.first_name            # => 'John'
puts bob.last_name             # => 'Adams'

puts "\n *********************************\n1\n2"


# => 4.

class Person
  attr_accessor :first_name, :last_name, :name
  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def <=> (other)
    self.name <=> other.name
  end

  def to_s
    name
  end


  private

  def parse_full_name(full_name)
    name_parts = full_name.split
    self.first_name = name_parts.first
    self.last_name = name_parts.count > 1 ? name_parts.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smithpp')
p bob <=> rob

# => 5.

puts "this is bob #{bob}"


# => 6.


