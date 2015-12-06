%w{
  models/character
  models/description
  models/page
  models/passage
  models/player
  models/inventory
  models/item
  models/equipment
  models/equippable_item
  models/page_item
  views/text_user_interface
  controllers/game
  protocols/user_interface
}.each do |src_path|

  require_relative 'src/' << src_path

end
