class ChatRoomsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_room_rights! , only: [:room, :controls, :addUserToRoom]

  def index

    @rooms = current_user.chat_rooms;

  end

  def room

    @room = ChatRoom.find_by_id(params[:id])
    if !@room
      redirect_to chat_path
    else

      @messages = ChatPost.last(15)


    end

  end

  def controls

    @room = ChatRoom.find_by_id(params[:id])
    @users = @room.users

  end

  def new
  end

  def addUserToRoom

    user = User.find_by_username(chat_room_add_user_params[:username])
    if !user
      user = User.find_by_email(chat_room_add_user_params[:username])
    end
    room = ChatRoom.find_by_id(params[:id])
    if user && !RoomRight.find_by(:chat_room_id => room.id,:user_id => user.id)

      roomRight = RoomRight.new(:chat_room_id => room.id, :user_id => user.id)
      roomRight.save
      redirect_to chat_room_control_path(room.id,room.name)

    else

      redirect_to chat_room_control_path(room.id,room.name)

    end

  end

  def create

    room = ChatRoom.new(name:chat_room_params[:name])
    if room.save

      roomRights = RoomRight.new(user_id:current_user.id, chat_room_id:room.id, level:1)

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

  def check_room_rights!

    chatRoom = ChatRoom.find_by_id(params[:id])

    if !current_user.chat_rooms.any? { |r| r.id == chatRoom.id }

      redirect_to chat_path

    end

  end

  private


  def chat_room_params
    params.require(:chat_room).permit(:name)
  end

  def chat_room_add_user_params
    params.require(:room_right).permit(:username)
  end

end
