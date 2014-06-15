class AddHighlightToChatRoomWebResource < ActiveRecord::Migration
  def change

    add_column :chat_room_web_resources, :highlight, :text, default: ''

  end
end
