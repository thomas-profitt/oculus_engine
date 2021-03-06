require_relative 'page'

class Character

  attr_accessor :spawn_page, :inventory, :equipment
  attr_reader :page, :previous_page

  def initialize(*args)
    case args.length
    when 1
      if args[0].class == Page
        @spawn_page = args[0]
      elsif args[0].class == Hash
        if args[0][:spawn_page]
          raise_unless_a_page args[0][:spawn_page]
          @spawn_page = args[0][:spawn_page]
        end
        @inventory = args[0][:inventory] if args[0].keys.include? :inventory
        @equipment = args[0][:equipment] if args[0].keys.include? :equipment
        if @inventory.class != Inventory || @equipment.class != Equipment
          raise TypeError
        end
      else
        raise TypeError, "When one argument is provided, it must be a Page " <<
          "or a Hash with a Page as the value of the :spawn_page key."
      end
    end
  end

  def go(page)
    raise_unless_a_page page
    @previous_page = @page
    @page = page
  end

  protected

  def raise_unless_a_page(maybe_a_page)
    unless maybe_a_page.class == Page
      raise TypeError, "Expected argumemt of type #{Page.name}; " <<
        "got #{maybe_a_page.class.name}"
    end
  end

end

