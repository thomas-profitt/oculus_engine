class Passage

  # A passage's condition must return a truthy value, or the passage is
  # inaccessible.

  attr_accessor :option, :destination, :descriptions,
    :departure_descriptions, :arrival_descriptions,
    :condition

  def initialize(option: nil, destination: nil,
    descriptions: [], departure_descriptions: [], arrival_descriptions: [],
    condition: -> () { true })
    @option = option
    @destination = destination
    @descriptions = descriptions
    @departure_descriptions = departure_descriptions
    @arrival_descriptions = arrival_descriptions
    @condition = condition
  end

  def description
    self.departure_descriptions.map(&:eval).compact.
      push("...").
      push(*self.arrival_descriptions.map(&:eval).compact).
      join("\n")
  end

end

