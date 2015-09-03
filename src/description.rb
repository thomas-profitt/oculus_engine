class Description

  attr_accessor :descriptions, :condition

  def initialize(*args)
  #descriptions: {}, condition: -> () { true })
    if args.length == 1 && args[0].class == String
      # An unconditional description
      @descriptions = { true => args[0] }
      @condition = -> () { true }
    elsif args.length == 2 &&
    !args.select { |o| o.class == String }.empty? &&
    !args.select { |o| o.class == Proc }.empty?
      # shorthand. A desciption for true and a condition, in whatever order
      @descriptions = { true => args.select { |o| o.class == String }.first }
      @condition = args.select { |o| o.class == Proc }.first
    elsif args.length == 2 &&
    !args.select { |o| o.class == Proc }.empty? &&
    args.select { |o| o.class != Proc }.first.class == Hash
      # shorthand. A condition and descriptions
      @condition = args.select { |o| o.class == Proc }.first
      @descriptions = args.select { |o| o.class == Hash }.first
      if @descriptions.values.map(&:class).uniq != [String]
        raise ArgumentError
      end
    elsif args.length == 1 && args[0].class == Hash
      # longhand
      @condition = args[0][:condition]
      @descriptions = args[0][:descriptions]
    else
      raise ArgumentError
    end
  end

  def eval
    @descriptions[@condition.call]
  end

end

