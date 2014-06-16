/**
 * Created by z on 16.6.2014.
 */
var APP = APP || {};
/*
 room.note_msg*/
APP.notes = (function(){

    var frame;
    var room_id;
    var socket;
    var notes={};
    var user_id;
    var noteState = 0;
    var noteEnabled = false;



    function init(sckt,r_id,frm){

        frame = frm;
        room_id = r_id;
        socket = sckt;

        socket.on_successful_connection(socketReady);

        $("#note-highlight-controls").click(function(){

            noteState = (noteState+1)%3

            switch(noteState){

                case 0 : {

                    noteEnabled = false;
                    $(this).find('span').find('span').html("disabled");
                    break;

                }
                case 1: {

                    noteEnabled = true;
                    $(this).find('span').find('span').html("enabled");
                    break;

                }
                case 2: {

                    noteEnabled = false;
                    $(this).find('span').find('span').html("remove");
                    break;

                }

            }

        });


    }

    function iframeClicked(e){

        if(noteEnabled){

            var text = prompt("Please enter note text","Write it here");
            if(text != null)
                newNoteFromCanvas(e.pageX, e.pageY,text);

        }

    }

    function socketReady(){

        socket.bind_on_channel("note_broadcast",noteReceived);
        socket.bind_on_dispatcher("list_all_notes_response",noteListReceived);
        user_id = socket.getUserId();

        socket.trigger('room.list_all_notes','')

    }

    function noteListReceived(data){

        for(var i = 0; i<data.notes.length; i++)
            createNote(data.notes[i]);

        redraw();

    }

    function redraw(){

        var curResId = APP.main_canvas.getCurrentResource().resource_id;

        for(var n in notes[curResId]){

            var note = notes[curResId][n];

            $(frame).contents().find('body').append(note.elem);

        }

    }

    function noteReceived(data){

        if(data.create){

            var a = createNote(data);
            APP.messages.showInfo("Note added.",2500);

            var curResId = APP.main_canvas.getCurrentResource().resource_id;

            if(curResId == data.resource_id)
                $(frame).contents().find('body').append(a);

        } else {

            if(notes[data.resource_id]){

                eraseNote(notes[data.resource_id][data.note_id]);
                delete notes[data.resource_id][data.note_id];
                APP.messages.showInfo("Note deleted",2500);

            }

        }

    }

    function eraseNote(note){

        $(note.elem).remove();

    }

    function createNote(data){

        if(!notes[data.resource_id])
            notes[data.resource_id] = {};

        notes[data.resource_id][data.note_id] = data;

        var elem = createNoteHtmlObj(data);

        notes[data.resource_id][data.note_id].elem = elem;

        return elem;

    }

    function createNoteHtmlObj(data){

        var a = $('<div/>',{

            style:"position:absolute;left:"+data.x+"px;top:"+data.y+"px;background-color:white;color:black;border: 2px solid #FF00FF;padding:5px",
            text:data.text

        });

        $(a).on('click',function(){ removeFromCanvas(data.resource_id,data.note_id) })

        return a;

    }

    function newNoteFromCanvas(x,y,text){

        var res = APP.main_canvas.getCurrentResource();
        socket.trigger('room.note_msg', {
            room_id:room_id,
            create:true,
            resource_id:res.resource_id,
            x:x,
            y:y,
            text:text,
            web_res: res.web_res
        })

    }

    function removeFromCanvas(res_id,id){

        if(noteState != 2)
            return false;

        if (notes[res_id][id].user_id == user_id){

            socket.trigger('room.note_msg', {
                room_id:room_id,
                create:false,
                resource_id:res_id,
                note_id:id
            })

        } else {

            APP.messages.showAlert("You can only delete your own notes",2500);

        }

    }

    return {

        newNote: newNoteFromCanvas,
        init:init,
        redraw:redraw,
        createNote:iframeClicked

    }

})(jQuery);


