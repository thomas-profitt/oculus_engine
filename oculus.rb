%w{character description game page passage player protocols/user_interface text_user_interface}.each do |src_path|
  require_relative 'src/' << src_path
end
