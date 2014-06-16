class ChatRoomWebResource < ActiveRecord::Base

  belongs_to :chat_room
  belongs_to :web_resource
  belongs_to :user
  has_many :note, :dependent => :delete_all

end
