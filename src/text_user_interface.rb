require 'protocol'
require 'colorize'
require_relative 'protocols/user_interface'

class TextUserInterface

  def get_player_option(player, keywords)
    # Loop until we get a valid option from the player
    input = nil
    description = player_place_description player
    print_description_next_iteration = true
    loop do
      if print_description_next_iteration
        clear ; puts description
      else
        print_description_next_iteration = true
      end
      print "\t> "
      input = STDIN.gets.strip.downcase

      break if player.place.options.include?(input) || keywords.include?(input)

      handle_invalid_player_option(player, keywords)
      print_description_next_iteration = false
    end
    input
  end

  def describe_chosen_passage(chosen_passage)
    puts chosen_passage.description
  end

  private

  def handle_invalid_player_option(player, keywords)
    puts "Valid options here are:"
    puts player.place.options.join(", ")
    puts keywords.join(", ")
  end

  def clear
      puts "\e[H\e[2J"
  end

  def player_place_description(player)

    pretty_place_description = player.place.description
    pretty_place_description.split(/\W+/).each do |word|
      player.place.options.each do |choice|
        if word.downcase == choice.downcase
          pretty_place_description.gsub! word, word.light_yellow
          # A break could go here, but that would break outermost loop too.
        end
      end
    end

    ret = player.place.name.black.on_white
    ret += "\n" << pretty_place_description
  end


  conform_to UserInterfaceProtocol
end

