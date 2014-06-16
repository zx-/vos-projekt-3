class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :chat_room_web_resource
      t.references :user

      t.integer :x
      t.integer :y
      t.text :text
      t.timestamps
    end
  end
end
