class Equipment

  attr_accessor :slots

  def initialize(*slot_names)
    unless slot_names.class == Array &&
    [[Symbol], [String]].include?(slot_names.map(&:class).uniq)
      raise TypeError, "slot_names must be an Array of Strings or Symbols"
    end
    @slots = {}
    slot_names.uniq!
    slot_names.each { |name| @slots[name.downcase.to_sym] = nil }
  end

end
