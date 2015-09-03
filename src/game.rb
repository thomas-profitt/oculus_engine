require 'colorize'

class Game

  def self.start(player)
    player.go player.spawn_place

    input = ""

    until input == "quit" do

      puts player.current_place.name.black.on_white
      puts player.current_place.description.yellow

      print "\t> "

      input = STDIN.gets.chomp.downcase
      redo if input.empty?

      chosen_passage = player.current_place.passages.select { |p|
        p.option.to_sym == input.to_sym
      }.first

      if chosen_passage && chosen_passage.condition.call
        puts chosen_passage.departure_descriptions.map(&:eval).join("\n")
        player.go chosen_passage.destination
        puts "...\n"
        puts chosen_passage.arrival_descriptions.map(&:eval).join("\n")
      end

    end

    return true

  end

end
