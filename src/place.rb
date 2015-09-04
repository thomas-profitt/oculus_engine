class Place

  attr_accessor :name, :descriptions, :passages

  def initialize(name: nil, descriptions: [], passages: [])
    @name = name
    @descriptions = descriptions
    @passages = passages
  end

  def description
    ret = []
    ret.push(*@descriptions.map(&:eval).compact)
    @passages.each { |p| ret.push(*p.descriptions.map(&:eval)) }

    ret.join "\n"
  end

end

