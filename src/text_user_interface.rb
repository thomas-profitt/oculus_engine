require 'readline'

require 'protocol'
require 'colorize'

require_relative 'protocols/user_interface'

class TextUserInterface

  def get_player_option(player, keywords)
    # Loop until we get a valid option from the player
    input = nil
    description = player_page_description player
    print_description_next_iteration = true
    loop do
      if print_description_next_iteration
        clear ; puts description
      else
        print_description_next_iteration = true
      end

      input = Readline.readline("\t> ", true)

      break if player.page.options.include?(input) || keywords.include?(input)

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
    puts player.page.options.map(&:light_yellow).join(", ")
    puts keywords.join(", ")
  end

  def clear
      puts "\e[H\e[2J"
  end

  def player_page_description(player)

    pretty_page_description = player.page.description
    pretty_page_description.split(/\W+/).each do |word|
      player.page.options.each do |option|
        if word.downcase == option.downcase
          pretty_page_description.gsub! word, word.light_yellow
        end
      end
    end

    ret = player.page.name.black.on_white
    ret += "\n" << pretty_page_description
  end


  conform_to UserInterfaceProtocol
end

