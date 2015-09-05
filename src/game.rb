require 'colorize'

class Game

  attr_accessor :player, :before_turn, :after_turn
  attr_reader :keywords

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

    @keywords = %w{quit wait}
  end

  def start()
    @player.go @player.spawn_place

    input = ""
    done = false
    redo_outer = false
    loop do

      redo_outer = false if redo_outer

      before_turn.call

      pretty_place_description = @player.place.description
      pretty_place_description.split(/\W+/).each do |word|
        @player.place.options.each do |choice|
          if word.downcase == choice.downcase
            pretty_place_description.gsub! word, word.light_yellow
            # A break could go here, but that would break outermost loop too.
          end
        end
      end

      chosen_passage = nil

      print_description = true
      loop do
        if print_description
          clear
          puts @player.place.name.black.on_white
          puts pretty_place_description
        end

        print "\t> "

        input = STDIN.gets.strip.downcase

        if input.empty?
          print_description = true
          redo
        end

        case input
        when "wait"
          redo_outer = true
        when "quit"
          done = true
        end

        break if done || redo_outer

        chosen_passage = @player.place.passages.select { |p|
          p.option.to_sym == input.to_sym
        }.first

        break if chosen_passage

        puts "Valid options here are:"
        puts @player.place.options.join(", ")
        puts @keywords.join(", ")
        print_description = false

      end

      break if done
      redo if redo_outer

      puts chosen_passage.condition.call
      if chosen_passage.condition.call
        @player.go chosen_passage.destination
        puts chosen_passage.description
      end

    end

    return true

  end

  def clear
      puts "\e[H\e[2J"
  end

end
