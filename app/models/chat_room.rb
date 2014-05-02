class ChatRoom < ActiveRecord::Base
  has_many :room_rights
  has_many :users, :through => :room_rights
  has_many :chat_posts

  has_many :chat_room_web_resources
  has_many :web_resources, :through => :chat_room_web_resources


end
