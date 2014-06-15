class ChatSocketController < WebsocketRails::BaseController

  before_filter :authenticate_user!

  def initialize_session

    # chat socket setup

  end

  def submit_message

    puts "message submmited #{message}"
    room_id = message[:room_id]

    post = ChatPost.new(chat_room_id:room_id,user_id:current_user.id,userName:current_user.username,text:message[:text])

    if post.save

      WebsocketRails[room_id].trigger(:message_broadcast, {userName:post.userName,text:post.text})

    end

  end

  def web_resource_highlight

    room_id = message[:room_id]
    WebsocketRails[room_id].trigger(:highlight_web_resource_broadcast,message)
    

  end

  def list_all_resources

    room_id = message[:room_id]

    if numeric? room_id

      resources = []
      ChatRoomWebResource.select("*").joins(:user,:web_resource).where("chat_room_id" => room_id).each do |res|

        resources << {
          resource_id:res.web_resource.id,
          image_url:ActionController::Base.helpers.asset_path(res.web_resource.image),
          title:res.web_resource.title,
          user_name:res.user.username,
          url:res.web_resource.url,
          html:res.web_resource.html_edited,
          highlights:''

        }

      end

      send_message :list_all_resources_response,{data:resources}

    end

  end

  def add_web_resource

    result = true
    room_id = message[:room_id]
    room_res = nil

    res = WebResource.add_url_resource(message[:url])


    if res

      if !ChatRoomWebResource.exists? web_resource_id:res.id,chat_room_id:room_id

        room_res = ChatRoomWebResource.new(
          web_resource_id:res.id,
          chat_room_id:room_id,
          user_id:current_user.id
        )

        if room_res && room_res.save

          send_message :add_web_resource_confirmation,{success:true}
          WebsocketRails[room_id].trigger(:add_web_resource_broadcast, {
              resource_id:res.id,
              image_url:ActionController::Base.helpers.asset_path(res.image),
              title:res.title,
              user_name:current_user.username,
              url:res.url,
              html:res.html_edited,
              highlights:''

          })

        else

          send_message :add_web_resource_confirmation,{success:false,message:"Error while saving"}

        end

      else

          send_message :add_web_resource_confirmation,{success:false,message:"Resource already exists"}

      end


    else

      send_message :add_web_resource_confirmation,{success:false,message:"i dont know man"}

    end

  end

  def authorize_channels
    # The channel name will be passed inside the message Hash

   # WebsocketRails[message[:channel]].make_private
    #channel = WebsocketRails[message[:channel]]

    if check_room_rights(message[:channel])
      accept_channel current_user
    else
      deny_channel({:reason => 'You shall not pass!'})
    end

  end


  private

  def numeric? (a)
    Float(a) != nil rescue false
  end

  def check_room_rights(room_id)

    puts "Check room rights for #{current_user} for room #{room_id}"
    if !connection_store[:room_id] || connection_store[:room_id]!=room_id

      chatRoom = ChatRoom.find_by_id(room_id)
      if current_user.chat_rooms.any? { |r| r.id == chatRoom.id }

        puts "Test passed using pg db"
        connection_store[:room_id] = room_id

      end

    else

      puts "Test passed without pg db"
      room_id

    end

  end

end