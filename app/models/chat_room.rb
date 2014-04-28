class ChatRoom < ActiveRecord::Base
  has_many :room_rights
  has_many :users, :through => :room_rights
  has_many :chat_posts
end
