require_relative 'item'
require_relative 'description'

class PageItem

  attr_accessor :item, :description

  def initialize(*args)
    case args.length
    when 1
      if args[0].is_a? Hash
        unless args[0][:item] && args[0][:item].is_a?(Item)
          raise ArgumentError, "args[0][:item] not provided or not an Item"
        end
        unless args[0][:description] && args[0][:description].is_a?(Description)
          raise ArgumentError, "args[0][:description] not provided or not a " <<
            "Description"
        end
        @item = args[0][:item]
        @description = args[0][:description]
      end
    else
      raise ArgumentError, "args length must be 1"
    end
  end

end

