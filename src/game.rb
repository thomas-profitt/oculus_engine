require 'colorize'

class Game

  attr_accessor :player, :before_turn, :after_turn

  def initialize(*args)
    if args.length == 1 && args[0].class == Player
      @player = args[0]
    elsif args.length == 1 && args[0].class == Hash
      @player = args[0][:player]
      @before_turn = args[0][:before_turn] if args[0][:before_turn]
      @after_turn = args[0][:after_turn] if args[0][:after_turn]
    else
      raise ArgumentError
    end
    @before_turn ||= -> {}
    @after_turn ||= -> {}
  end

  def start()
    @player.go @player.spawn_place

    input = ""

    until input == "quit" do

      before_turn.call

      puts @player.place.name.black.on_white
      puts @player.place.description.yellow

      print "\t> "

      input = STDIN.gets.chomp.downcase
      redo if input.empty?

      chosen_passage = @player.place.passages.select { |p|
        p.option.to_sym == input.to_sym
      }.first

      puts chosen_passage.condition.call
      if chosen_passage && chosen_passage.condition.call
        @player.go chosen_passage.destination
        puts chosen_passage.description
      end

    end

    return true

  end

end
