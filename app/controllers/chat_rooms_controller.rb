class ChatRoomsController < ApplicationController

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

  def new



  end

  def create

    room = ChatRoom.new(name:chat_room_params[:name])
    if room.save

      roomRights = RoomRight.new(user_id:current_user.id, chat_room_id:room.id)

      if roomRights.save

        redirect_to chat_room_path(room.id,room.name)

      else

        room.destroy!
        redirect_to new_chat_room_path

      end

    else

      redirect_to new_chat_room_path

    end

  end

  private


  def chat_room_params
    params.require(:chat_room).permit(:name)
  end

end
