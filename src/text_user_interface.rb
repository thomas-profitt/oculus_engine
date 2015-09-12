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
        puts description
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
    clear
    puts chosen_passage.description
  end

  private

  def clear
    puts "\e[H\e[2J"
  end

  def handle_invalid_player_option(player, keywords)
    puts "Valid options here are:"
    if !player.page.options.empty?
      puts player.page.options.map(&:light_yellow).join(", ")
    end
    puts keywords.join(", ")
  end

  def player_page_description(player)

    words_to_replace = []
    page_description = player.page.description
    # Eval it only once and store the result

    page_description.split(/\W+/).each do |word|
      player.page.options.each do |option|
        if word.downcase == option.downcase
          words_to_replace << word
        end
      end
    end

    words_to_replace.uniq!

    # Regexp.new("([])") would cause a RegexpError
    unless words_to_replace.empty?
      regexp_string =
        "(" << words_to_replace.map { |s| "(#{s})" }.join("|") << ")"
      pretty_page_description =
        page_description.
        gsub(
          Regexp.new(regexp_string, true),
          '\1'.light_yellow)
          # The gsub must be done all at once, or it could gsub parts of the
          # color-formatted parts of the string and mangle it.
    else
      pretty_page_description = page_description
    end

    ret = player.page.name ? player.page.name.black.on_white << "\n" : ""
    ret << pretty_page_description
  end


  conform_to UserInterfaceProtocol
end

