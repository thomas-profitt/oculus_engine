class Item

  attr_accessor :name, :short_name, :slots

  def initialize(*args)
    case args.length
    when 1
      if args[0].class == Hash
        if args[0].keys.include?(:name)
          @name = args[0][:name]
          if @name.class != String
            raise TypeError, "name must be a string."
          end
          if args[0][:short_name].is_a? String
            @short_name = args[0][:short_name]
          end
        else
          raise ArgumentError, "name not given"
        end
        if args[0].keys.include?(:slots) && args[0][:slots].class == Fixnum
          @slots = args[0][:slots]
        end
      end
    end
    @slots ||= 1
  end

end
