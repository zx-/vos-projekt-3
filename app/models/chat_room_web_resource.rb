class ChatRoomWebResource < ActiveRecord::Base

  has_many :chat_rooms,
  has_many :web_resources

end
