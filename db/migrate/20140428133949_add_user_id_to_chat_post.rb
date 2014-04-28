class AddUserIdToChatPost < ActiveRecord::Migration
  def change
    add_column :chat_posts, :user_id, :integer
  end
end
