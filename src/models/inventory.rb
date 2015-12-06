class Inventory

  attr_accessor :max_slots, :items

  def initialize(*args)
    case args.length
    when 1
      if args[0].class == Hash
        @items = args[0][:items] if args[0].keys.include? :items
        @max_slots = args[0][:max_slots] if args[0].keys.include? :max_slots
      elsif args[0].class == Fixnum
        @max_slots = args[0]
      else
        raise TypeError, "When given a single argument, " <<
                         "it must be a hash or Fixnum."
      end
    end
    @max_slots ||= 0
    @items ||= []
  end

  def used_slots
    @items.map(&:slots).inject(:+)
  end

  def unused_slots
    @max_slots - used_slots
  end

  def try_to_add(item)
    if unused_slots >= item.slots
      @items << item
      return true
    else
      return false
    end
  end

end
