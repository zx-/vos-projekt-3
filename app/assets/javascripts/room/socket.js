/**
 * Created by z on 13.6.2014.
 */
var APP = APP || {};

APP.socket = (function($){

    var dispatcher,channel;
    var onSuc = [];
    var userId;

    function init(room_id){


        dispatcher = new WebSocketRails(window.document.location.host+'/websocket');
        channel = dispatcher.subscribe_private(room_id);
        channel.on_success = successful_connection;
        channel.on_failure = failed_connection;

        dispatcher.on_open = function(data) {
            console.log('Connection has been established: ', data);
        }

    }



    function successful_connection(data){

        console.log( "Joined channel ");
        console.log(data);
        userId = data.id;

        for(var i=0;i<onSuc.length;i++)
            onSuc[i].call();

    }

    function failed_connection(reason){

        console.log( "Authorization failed because " + reason.message );
        APP.messages.showAlert("Unable to connect to server",2500);

    }

    function on_successful_connection(f){

        onSuc.push(f);

    }

    function trigger(a,b){

        dispatcher.trigger(a,b);

    }
    function bind_on_channel(a,b){

        channel.bind(a,b);

    }
    function wait(){

        console.log("Socket waiting for elems")

    }

    function bind_on_dispatcher(a,b){

        dispatcher.bind(a,b);

    }

    function getUserId(){

        return userId;

    }

    return {

        trigger:trigger,
        bind_on_channel:bind_on_channel,
        bind_on_dispatcher:bind_on_dispatcher,
        on_successful_connection:on_successful_connection,
        init:init,
        wait:wait,
        getUserId:getUserId

    }

})(jQuery);