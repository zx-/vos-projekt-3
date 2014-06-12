class AddAddedByToChatRoomWebResource < ActiveRecord::Migration
  def change

    add_column :chat_room_web_resources, :user_id, :integer, references: :users

  end
end
