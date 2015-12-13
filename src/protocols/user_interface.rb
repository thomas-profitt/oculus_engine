require 'protocol'

UserInterfaceProtocol = Protocol do

  def get_player_option(player, keywords)
  end

  def describe_chosen_passage(chosen_passage)
  end

  def describe_trying_to_add_item_to_inventory(item, inventory, successful)
  end

  def inventory_and_equipment_menu(player)
  end

  def inspect_item(item)
  end

end

