class Place

  attr_accessor :name, :description, :conditional_descriptions,
                :entrances, :exits

  def initialize(name: nil, description: nil, conditional_descriptions: [],
                 entrances: {}, exits: {})
    @name = name
    @description = description
    @conditional_descriptions = conditional_descriptions
    @entrances = entrances
    @exits = exits
  end

end

