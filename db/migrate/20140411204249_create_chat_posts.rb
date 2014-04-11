class CreateChatPosts < ActiveRecord::Migration
  def change
    create_table :chat_posts do |t|
      t.string :userName
      t.text :text
      t.integer :room

      t.timestamps
    end

    add_index :chat_posts, :room, :unique => false
  end
end
