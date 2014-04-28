class ChatController < ApplicationController

  before_filter :authenticate_user!

  def index

    @rooms = current_user.chat_rooms;

  end

  def room

    @chatRoom = ChatRoom.find_by_id(params[:id])
    redirect_to chat_path unless check_room_rights(current_user,@chatRoom)

  end




  def check_room_rights(user,room)

    user.chat_rooms.any? { |r| r.id == room.id }

  end


end
