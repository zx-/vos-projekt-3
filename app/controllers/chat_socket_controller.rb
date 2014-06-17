class ChatSocketController < WebsocketRails::BaseController

  before_filter :authenticate_user!

  def initialize_session

    # chat socket setup

  end

  def submit_message

    puts "message submmited #{message}"
    #room_id = message[:room_id]
    room_id = connection_store[:room_id]

    post = ChatPost.new(chat_room_id:room_id,user_id:current_user.id,userName:current_user.username,text:message[:text])

    if post.save

      WebsocketRails[room_id].trigger(:message_broadcast, {userName:post.userName,text:post.text})

    end

  end

  def web_resource_highlight

    #room_id = message[:room_id]
    room_id = connection_store[:room_id]
    WebsocketRails[room_id].trigger(:highlight_web_resource_broadcast,message)
    res = ChatRoomWebResource.find_by(web_resource_id:message[:resource_id])
    res.highlight = message[:highlight]
    res.save
    puts res

  end

  def list_all_resources

    #room_id = message[:room_id]
    room_id = connection_store[:room_id]

    resources = []
    ChatRoomWebResource.includes(:user,:web_resource).where("chat_room_id" => room_id).each do |res|

      resources << {
        resource_id:res.web_resource.id,
        image_url:res.web_resource.get_image_url,
        title:res.web_resource.title,
        user_name:res.user.username,
        user_id:res.user_id,
        url:res.web_resource.url,
        html:res.web_resource.html_edited,
        highlight:res.highlight,
        web_res:res.id,

      }

    end

    send_message :list_all_resources_response,{data:resources}

  end

  def list_all_notes
    #list_all_notes_response

    #room_id = message[:room_id]
    room_id = connection_store[:room_id]
    notes = []

    puts "all notes"
    ChatRoomWebResource.includes(:note).where("chat_room_id" => room_id).each do |res|

      res.note.each do |note|

        notes << {

            resource_id:res.web_resource_id,
            user_id:note.user_id,
            note_id:note.id,
            x:note.x,
            y:note.y,
            text:note.text,
            create:true

        }

      end

    end

    send_message :list_all_notes_response,{notes:notes}


  end

  def add_web_resource

    result = true
    #room_id = message[:room_id]
    room_id = connection_store[:room_id]
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
              image_url:res.get_image_url,
              title:res.title,
              user_name:current_user.username,
              user_id:current_user.id,
              url:res.url,
              html:res.html_edited,
              highlight:'',
              web_res:room_res.id
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

    if check_room_rights(message[:channel])
      accept_channel current_user
    else
      deny_channel({:reason => 'You shall not pass!'})
    end

  end

  def remove_web_resource

    #room_id = message[:room_id]
    room_id = connection_store[:room_id]
    user_id = current_user.id
    resource_id = message[:resource_id]

    res = ChatRoomWebResource.find_by(web_resource_id:resource_id)
    puts "res u id #{res.user_id} userid #{user_id} res #{resource_id}"

    if res.user_id == user_id

      puts res
      res.destroy

      WebsocketRails[room_id].trigger(:remove_web_resource_broadcast,{

          resource_id:resource_id

      })

    end

  end

  def note_msg

    user = current_user.id
    #room_id = message[:room_id]
    room_id = connection_store[:room_id]
    create = message[:create]
    res_id = message[:resource_id]
    web_res = message[:web_res]



    if create

      note = Note.new(
          user_id:current_user.id,
          chat_room_web_resource_id:web_res,
          x:message[:x],
          y:message[:y],
          text:message[:text]
      )

      if note.save

        message[:user_id] = current_user.id
        message[:note_id] = note.id
        WebsocketRails[room_id].trigger(:note_broadcast,message)

      end

    else

      note = Note.find_by(id:message[:note_id])

      if note && note.user_id == current_user.id

        note.destroy
        WebsocketRails[room_id].trigger(:note_broadcast,message)

      end


    end



  end


  private

  def numeric? (a)
    Float(a) != nil rescue false
  end

  def check_room_rights(room_id)

    puts "Check room rights for #{current_user} for room #{room_id}"
    if !connection_store[:room_id] || connection_store[:room_id]!=room_id


      if RoomRight.find_by(user_id:current_user.id,chat_room_id:room_id)

        puts "Test passed using pg db"
        connection_store[:room_id] = room_id

        return room_id

      end

    else

      puts "Test passed without pg db"
      return room_id

    end

    return false

  end

end