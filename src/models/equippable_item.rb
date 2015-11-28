require_relative 'item'

class EquippableItem < Item

  attr_accessor :equipment_slot

  def initialize(*args)
    super
    @equipment_slot = args[0][:equipment_slot]
  end

end
