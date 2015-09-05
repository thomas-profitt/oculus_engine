require 'colorize'
require_relative 'protocols/user_interface'
require_relative 'text_user_interface' # default user_interface

class Game

  attr_accessor :player,         :before_turn,
                :after_turn,     :user_interface

  attr_reader   :keywords

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
    else
      raise ArgumentError
    end
    @before_turn ||= -> {}
    @after_turn ||= -> {}
    @user_interface ||= TextUserInterface.new

    @keywords = %w{quit exit wait}
  end

  def start()
    @player.go @player.spawn_place

    chosen_option = ""
    loop do

      before_turn.call

      chosen_option = @user_interface.get_player_option player, @keywords

      case chosen_option
      when "wait"
        redo
      when "quit", "exit"
        break
      end

      chosen_passage = @player.place.passages.select { |p|
        p.option == chosen_option
      }.first

      if chosen_passage.condition.call
        @player.go chosen_passage.destination
        @user_interface.describe_chosen_passage chosen_passage
      end

    end

    return true
  end

end
