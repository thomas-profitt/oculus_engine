require 'colorize'
require 'numeric_range_utils'
require_relative '../protocols/user_interface'
require_relative '../views/text_user_interface' # default user_interface

class Game

  attr_accessor :player,         :before_turn,
                :after_turn,     :user_interface,
                :allow_wait

  attr_reader   :keywords,       :turn_rand

  def initialize(*args)
    if args.length == 2 &&
    !args.select { |o| o.class == Player }.empty? &&
    !args.select { |o| o.class != Player && o.conform_to?(UserInterface)}.empty?
      @player = args.select { |o| o.class == Player }
      @user_interface = args.select { |o| o.class != Player }
    elsif args.length == 1 && args[0].class == Hash
      @player = args[0][:player]
      @before_turn = args[0][:before_turn] if args[0][:before_turn]
      @after_turn = args[0][:after_turn] if args[0][:after_turn]
      @user_interface = args[0][:user_interface] if args[0][:user_interface]
      if args[0].keys.include? :allow_wait
        @allow_wait = args[0][:allow_wait]
        allow_wait_provided = true
      end
    elsif args.length == 1 && args[0].class == Player
      @player = args[0]
    else
      raise ArgumentError
    end
    @before_turn ||= -> {}
    @after_turn ||= -> {}
    @user_interface ||= TextUserInterface.new

    @keywords = %w{quit exit inventory}
    @allow_wait = true unless allow_wait_provided
    @keywords << "wait" if @allow_wait
    @turn_rand = rand
  end

  def start
    @player.go @player.spawn_page

    chosen_option = ""
    new_turn = true
    loop do
      if new_turn
        @turn_rand = rand

        before_turn.call
      else
        new_turn = true
      end

      chosen_option = @user_interface.get_player_option player, @keywords

      case chosen_option
      when "wait"
        redo if @allow_wait
      when "quit", "exit"
        break
      end

      chosen_passage = @player.page.passages.select { |p|
        p.option == chosen_option
      }.first

      if chosen_passage
        if chosen_passage.condition.call
          @player.go chosen_passage.destination
          @user_interface.describe_chosen_passage chosen_passage
          chosen_passage.after_departure.call
        end
      elsif chosen_option =~ /\Aget .*\z/ || chosen_option =~ /\Ainspect .*\z/
        chosen_option[/\A(.*) /] and chosen_verb = $1
        chosen_item_name = chosen_option.split(/\A#{chosen_verb} /).last
        chosen_page_item = @player.page.page_items.select { |pi|
          [pi.item.short_name.downcase, pi.item.name.downcase].
            include?(chosen_item_name.downcase)
        }.first
        chosen_item = chosen_page_item.item
        if chosen_verb == "get"
          successful = @player.inventory.try_to_add(chosen_item)
          @user_interface.describe_trying_to_add_item_to_inventory(
            chosen_item,
            @player.inventory,
            successful
          )
          @player.page.page_items.delete chosen_page_item if successful
        elsif chosen_verb == "inspect"
          @user_interface.inspect_item(chosen_item)
        end
        new_turn = false
      elsif chosen_option == "inventory"
        @user_interface.describe_inventory(@player.inventory)
        new_turn = false
      end

    end

    return true
  end

  def turn_rand(values = nil)
    return @turn_rand unless values
    NumericRangeUtils.shift_proportions(@turn_rand, 0..1, (0..values - 1)).round
  end

end
