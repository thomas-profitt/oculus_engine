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

    @keywords = %w{quit wait}
  end

  def start()
    @player.go @player.spawn_place

    chosen_option = ""
    done = false
    redo_outer = false
    loop do

      redo_outer = false if redo_outer

      before_turn.call

      chosen_passage = nil

      describe_place = true
      loop do
        if describe_place
        end

        chosen_option = @user_interface.get_player_option player, @keywords

        if chosen_option.empty?
          describe_place = true
          redo
        end

        case chosen_option
        when "wait"
          redo_outer = true
        when "quit"
          done = true
        end

        break if done || redo_outer

        chosen_passage = @player.place.passages.select { |p|
          p.option == chosen_option
        }.first

        break if chosen_passage

        describe_place = false

      end

      break if done
      redo if redo_outer

      if chosen_passage.condition.call
        @player.go chosen_passage.destination
        @user_interface.describe_chosen_passage chosen_passage
      end

    end

    return true

  end

end
