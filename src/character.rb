require_relative 'page'

class Character

  attr_reader :page, :previous_page
  attr_accessor :spawn_page

  def initialize(*args)
    case args.length
    when 1
      if args[0].class == Page
        @spawn_page = args[0]
      elsif args[0].class == Hash
        raise_unless_a_page args[0][:spawn_page]
        @spawn_page = args[0][:spawn_page]
      else
        raise ArgumentError
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
      raise "Expected argumemt of type #{Page.name}; " <<
        "got #{maybe_a_page.class.name}"
    end
  end

end

