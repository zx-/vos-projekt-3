class AddChatRoomIdToChatPost < ActiveRecord::Migration
  def change
    add_column :chat_posts, :chat_room_id, :integer
  end
end
