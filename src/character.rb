require_relative 'place'

class Character

  attr_reader :place, :previous_place
  attr_accessor :spawn_place

  def initialize(spawn_place: nil)
    raise_unless_a_place spawn_place
    @spawn_place = spawn_place
  end

  def go(place)
    raise_unless_a_place place
    @previous_place = @place
    @place = place
  end

  protected

  def raise_unless_a_place(maybe_a_place)
    unless maybe_a_place.class == Place
      raise "Expected argumemt of type #{Place.name}; " <<
        "got #{maybe_a_place.class.name}"
    end
  end

end

