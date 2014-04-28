class CreateRoomRight < ActiveRecord::Migration
  def change
    create_table :room_rights do |t|

      t.belongs_to :user
      t.belongs_to :chat_room
      t.timestamps

    end
  end
end
