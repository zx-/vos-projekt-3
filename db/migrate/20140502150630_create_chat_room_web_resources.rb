class CreateChatRoomWebResources < ActiveRecord::Migration
  def change
    create_table :chat_room_web_resources do |t|

      t.belongs_to :web_resource
      t.belongs_to :chat_room
      t.timestamps
    end
  end
end
