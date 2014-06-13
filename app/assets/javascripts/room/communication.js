/**
 * Created by z on 13.6.2014.
 *//*
$(function(){

    $("#addResourceToroom").on("ajax:success", function(e, data, status, xhr) {


        if(data.data){

            $("#resourceList").append(data.data)

        }
        console.log(data)

    }).on("ajax:error", function(e, xhr, status, error){

        console.log(error);

    })


    // GUI

    $( "#resourceContainer" ).resizable({minWidth:165}).draggable();

    $( "#chat-box" ).resizable({

        minHeight: 320,
        minWidth: 320

    }).draggable();

    var dispatcher = new WebSocketRails('rarcoo.synology.me:3000/websocket');
    var channel = dispatcher.subscribe_private(room_id);

    channel.on_success = function(data) {
        console.log( "Joined channel ");
        console.log(data)
        textarea.removeProp('disabled');

        channel.bind('message_broadcast', function(data) {

            console.log('Message recieved: ' + data);
            messagebox.append('<div><span class ="chat-userName">'+data.userName+':</span><p class="">'+data.text+'</p></div>');
            messagebox.animate({ scrollTop: 2000 },messagebox.height);

        });

    }

    channel.on_failure = function(reason) {
        console.log( "Authorization failed because " + reason.message );
        }



    var textarea = $('.chat textarea');
        var messagebox = $('.chat-message-box')

        messagebox.animate({ scrollTop: 2000 },messagebox.height);

        dispatcher.on_open = function(data) {
            console.log('Connection has been established: ', data);
        };


        textarea.keyup();


});

 */   //dispatcher.trigger('chat.submit_message', object_to_send);