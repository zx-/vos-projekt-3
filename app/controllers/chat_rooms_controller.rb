class ChatRoomsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_room_rights! , only: [:room, :controls, :addUserToRoom, :add_resource]

  respond_to :html, :js

  def index

    @rooms = current_user.chat_rooms

  end

  def room

    @room = ChatRoom.find_by_id(params[:id])
    if !@room
      redirect_to chat_path
    else

      @messages = @room.chat_posts.last(15)
      room_resource = @room.chat_room_web_resources
      @resources = []

      room_resource.each do |res|

        @resources << {
          added_by:res.user.username,
          title:res.web_resource.title,
          url:res.web_resource.url,
          image:res.web_resource.image
        }

      end

    end

  end

  def add_resource

    @res = WebResource.add_url_resource(chat_room_add_resource_params[:url])
    if @res

      room_res = ChatRoomWebResource.new(
          web_resource_id:@res.id,
          chat_room_id:params[:id],
          user_id:current_user.id
      )

    end

    if request.xhr?

      if room_res && room_res.save
        @room_res = @room_res
        @user = current_user.username
        render json: {data:render_to_string(partial: "add_resource")}
      else
        render json:{data:nil}
      end

    else

      redirect_to chat_room_path(room.id,room.name)

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
      if request.xhr?
        render json: {name:user.username}
      else
        redirect_to chat_room_control_path(room.id,room.name)
      end

    else

      if request.xhr?
        render json: {name:nil}
      else
        redirect_to chat_room_control_path(room.id,room.name)
      end

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

  def chat_room_add_resource_params
    params.require(:web_resource).permit(:url)
  end

end
