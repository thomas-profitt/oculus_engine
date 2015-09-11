require_relative 'page'

class Character

  attr_reader :page, :previous_page
  attr_accessor :spawn_page

  def initialize(spawn_page: nil)
    raise_unless_a_page spawn_page
    @spawn_page = spawn_page
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

