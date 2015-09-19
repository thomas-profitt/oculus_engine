%w{models/character models/description controllers/game models/page models/passage models/player protocols/user_interface views/text_user_interface}.each do |src_path|
  require_relative 'src/' << src_path
end
