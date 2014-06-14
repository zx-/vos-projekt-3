class AddValidationToChatRoomWebResource < ActiveRecord::Migration
  def change

    add_index :chat_room_web_resources, [:web_resource_id,:chat_room_id], :unique => true,:name => 'unique_res_index'

  end
end
