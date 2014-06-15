function ChatBox(socket,room_id,textarea,messagebox) {

    this.textarea=textarea;
    this.messagebox = messagebox;
    this.socket = socket;
    this.room_id;

    this.textAreaEvent= function(e){

        if(e.which == 13 && e.shiftKey == false){

            e.preventDefault();

            var data = this.value.slice(0,-1);
            this.value='';
            if (data.length!=0 && !data.match(/^\s*$/)){

                socket.trigger('room.submit_message', {room_id:room_id,text:data});

            }
        }

    }

    this.init = function(){

        this.messagebox.animate({ scrollTop: 2000 },messagebox.height);
        this.textarea.keyup(this.textAreaEvent);
        this.socket.on_successful_connection(this.ready.bind(this));

    }

    this.ready = function(){

        console.log("ready")
        this.textarea.removeProp('disabled');

        var incMsg = this.incoming_message.bind(this);
        this.socket.bind_on_channel('message_broadcast', incMsg);

    }

    this.incoming_message = function(data){

        console.log('Message recieved: ' + data);
        this.messagebox.append('<div><span class ="chat-userName">'+data.userName+':</span><p class="">'+data.text+'</p></div>');
        this.messagebox.animate({ scrollTop: 2000 },messagebox.height);

    }


    this.init();

}



