/**
 * Created by z on 13.6.2014.
 */
var APP = APP || {};

APP.socket = (function($){

    var dispatcher,channel,textarea,messagebox;

    function init(room_id,t_area,msg_box){

        textarea = t_area;
        messagebox = msg_box;

        messagebox.animate({ scrollTop: 2000 },messagebox.height);

        dispatcher = new WebSocketRails('rarcoo.synology.me:3000/websocket');
        channel = dispatcher.subscribe_private(room_id);
        channel.on_success = successful_connection;
        channel.on_failure = failed_connection;

        dispatcher.on_open = function(data) {
            console.log('Connection has been established: ', data);
        }

        textarea.keyup(textAreaEvent);

    }

    function textAreaEvent(e){

        if(e.which == 13 && e.shiftKey == false){

            e.preventDefault();

            var data = this.value.slice(0,-1);
            this.value='';
            if (data.length!=0 && !data.match(/^\s*$/)){

                dispatcher.trigger('chat.submit_message', {room_id:room_id,text:data});

            }
        }

    }

    function successful_connection(data){

        console.log( "Joined channel ");
        console.log(data)
        textarea.removeProp('disabled');

        channel.bind('message_broadcast', function(data) {

            console.log('Message recieved: ' + data);
            messagebox.append('<div><span class ="chat-userName">'+data.userName+':</span><p class="">'+data.text+'</p></div>');
            messagebox.animate({ scrollTop: 2000 },messagebox.height);


        });

    }

    function failed_connection(reason){

        console.log( "Authorization failed because " + reason.message );
        APP.messages.showAlert("Unable to connect to server",2500);

    }

    return {

        init:init

    }

})(jQuery);