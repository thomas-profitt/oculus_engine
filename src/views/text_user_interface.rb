require 'readline'

require 'protocol'
require 'colorize'

require_relative '../protocols/user_interface'

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

  def describe_trying_to_add_item_to_inventory(item, inventory, successful)
    if successful
      puts "You put #{item.name} into your inventory."
    else
      puts "You could not fit #{item.name} into your inventory."
    end
  end

  def inventory_and_equipment_menu(player)
    inventory = player.inventory
    equipment = player.equipment
    puts "-----Inventory"
    puts "#{inventory.used_slots}/#{inventory.max_slots} slots used"
    puts "-----"
    puts "slots | Item (equipment slot)"
    inventory.items.each do |item|
      row = "#{"%6d" % item.slots}| #{item.name}"
      if item.respond_to?(:equipment_slot)
        row << " (#{item.equipment_slot})"
      end
      puts row
    end
    puts "-----"
    puts "-----Equipment"
    equipment.slots.each do |slot, item|
    puts "#{slot}: #{item.respond_to?(:name) ? item.name : "<Empty>"}"
    end
    puts "-----"
    puts "[equip, unequip, put, exit]: "
    while input = gets.strip
      break if input.downcase == "exit"
      match_data = input.match(/\A(equip|unequip|put) (.*)\z/)
      input_verb = match_data[1]
      input_item = match_data[2]
      case input_verb
      when "equip"
        item = inventory.items.select do |i|
          [i.name.downcase, i.short_name.downcase].include? input_item
        end.first
        unless item
          puts "\"#{input_item}\" not found"
          return false
        end
        unless item.is_a?(EquippableItem) &&
        equipment.slots.keys.include?(item.equipment_slot)
          puts "\"#{input_item}\" is not equippable."
        end
        equipment.slots[item.equipment_slot] = item
        inventory.items.delete item
        inventory_and_equipment_menu(player)
      when "unequip"
        item = equipment.items.select do |i|
          [i.name.downcase, i.short_name.downcase].include? input_item
        end.first
        unless item
          puts "\"#{input_item}\" not found"
          return false
        end
        if inventory.try_to_add item
          puts "\"#{item.name}\" unequipped and added to inventory"
        else
          puts "\"There's not enough room in your inventory for #{item.name}.\""
        end
      when "put"
        item = inventory.items.select do |i|
          [i.name.downcase, i.short_name.downcase].include? input_item
        end.first
        inventory.items.delete item
        player.page.page_items << PageItem.new(
          item: item,
          description: Description.new("You placed #{item.name} here.")
        )
      when "exit"
        return
      end
    end
  end

  def inspect_item(item)
    if item.descriptions
      puts item.descriptions.map(&:eval).join("\n")
    end
  end

  private ######################################################################

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

    words_to_replace.push(
      *player.page.page_items.map(&:item).
        map { |i| [i.short_name, i.name] }.flatten
    )

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

