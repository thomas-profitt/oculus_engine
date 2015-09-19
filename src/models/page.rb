class Page

  attr_accessor :name, :descriptions, :passages

  def initialize(*args)
    case args.length
    when 1
      if args[0].class == Hash
        @name = args[0][:name] || nil
        @descriptions = args[0][:descriptions] || []
        @passages = args[0][:passages] || []
      elsif args[0].class == String
        @name = args[0]
      elsif args[0].class == Array &&
      args[0].map(&:class).unique == [Description]
        @descriptions = args[0]
      else
        raise TypeError, "When one argument is provided, it must be a "<<
          "Hash, String or Array of Descriptions"
      end
    end

    @name ||= nil
    @descriptions ||= []
    @passages ||= []

  end

  def description
    ret = []
    ret.push(*@descriptions.map(&:eval).compact)
    @passages.each { |p| ret.push(*p.descriptions.map(&:eval)) }

    ret.join "\n"
  end

  def options(all = false)
    ret = []
    if all
      ret.push(*@passages.map(&:option))
    else
      ret.push(*@passages.select { |p| p.condition.call }.map(&:option))
    end
    ret
  end

end

