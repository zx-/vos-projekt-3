class ChatRoomWebResource < ActiveRecord::Base

  belongs_to :chat_room
  belongs_to :web_resource
  belongs_to :user

end
