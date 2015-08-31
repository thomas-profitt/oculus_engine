class Character

  attr_reader :current_place, :previous_place
  attr_accessor :spawn_place

  def initialize(spawn_place: nil)
    raise_unless_a_place spawn_place
    @spawn_place = spawn_place
  end

  def go(place)
    raise_unless_a_place place
    @previous_place = @current_place
    @current_place = place
  end

  protected

  def raise_unless_a_place(maybe_a_place)
    unless place.class == Place
      raise "Expected argumemt of type #{Place.name}; got #{place.class.name}"
    end
  end

end

