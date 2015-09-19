class Passage

  # A passage's condition must return a truthy value, or the passage is
  # inaccessible.

  #FIXME: some_passage.description
  #       some_passage.descriptions

  attr_accessor :option, :destination, :descriptions,
    :departure_descriptions, :arrival_descriptions,
    :condition, :after_departure

  def initialize(option: nil, destination: nil,
    descriptions: [], departure_descriptions: [], arrival_descriptions: [],
    condition: -> () { true }, after_departure: -> () { })
    @option = option.to_s.downcase
    @destination = destination
    @descriptions = descriptions
    @departure_descriptions = departure_descriptions
    @arrival_descriptions = arrival_descriptions
    @condition = condition
    @after_departure = after_departure
  end

  def description
    self.departure_descriptions.map(&:eval).compact.
      push("...").
      push(*self.arrival_descriptions.map(&:eval).compact).
      join("\n")
  end

end

