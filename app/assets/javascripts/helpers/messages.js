/**
 * Created by z on 13.6.2014.
 */


var APP = APP || {};

APP.messages = (function($){
    /*
     danger
     success
     info
     warning*/

    function showMessage(type,errorText,text,time){

        var e = $(
                "<div class='alert alert-"+type+" alert-dismissable'>"+
                "<button type=button class=close data-dismiss=alert aria-hidden=true>&times;</button>"+
                "<strong>"+errorText+"</strong> "+text+
                "</div>"
        );

        $("#system-message-box").append(e);

        setTimeout(function() {
            $(e).fadeOut('fast');
            $(e).remove();
        }, 5000); // <-- time in milliseconds


    }


    function alertMessage( text,time ){

        showMessage("danger","Error!",text,time);

    }

    function successMessage(text,time){

        showMessage("success","",text,time);

    }

    function infoMessage(text,time){

        showMessage("info","Info!",text,time);

    }


    return {

        showAlert: alertMessage,
        showSuccess: successMessage,
        showInfo: infoMessage

    }

})(jQuery);