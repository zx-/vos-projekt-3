/**
 * Created by z on 14.6.2014.
 */
var APP = APP || {};

APP.main_canvas = (function($){

    var frame;
    var body;
    var doc;
    var currentWebres = null;
    var room_id;
    var socket;
    var resources;
    var highlightEnabled = false;
    var highlightState = 0;

    function init(sckt,r_id,res,frm){

        resources = res;
        socket = sckt;
        room_id = r_id;
        frame =  frm;
        doc  = frame[0].contentWindow.document;
        body = $('body',doc);

        showDefaultHtml();

        $.textHighlighter.createWrapper = function(options) {

            var wrapper = $('<span></span>');
            return $(wrapper)
                .addClass(options.highlightedClass)
                .css('background-color', options.color);
        };


        var initializeTextHighlighter = function() {
            var frameDocument = $(frame).contents();
            frameDocument.textHighlighter({
                onAfterHighlight: function(highlights, range) {
                    APP.main_canvas.textHighlighted();
                },
                onBeforeHighlight:function(range){
                    return APP.main_canvas.isHighlightEnabled();
                },
                highlightedClass: "room-highlighted-text"
            });
        };

        $(frame).load(initializeTextHighlighter);  // Non-IE
        $(frame).ready(initializeTextHighlighter); // IE

        socket.on_successful_connection(socketReady)

        $("#room-highlight-controls").click(function(){

            highlightState = (highlightState+1)%3

            switch(highlightState){

                case 0 : {

                    highlightEnabled = false;
                    $(this).find('span').find('span').html("disabled");
                    break;

                }
                case 1: {

                    highlightEnabled = true;
                    $(this).find('span').find('span').html("enabled");
                    break;

                }
                case 2: {

                    highlightEnabled = false;
                    $(this).find('span').find('span').html("remove");
                    break;

                }

            }

        })



        var iframeHtml = $(frame).contents().find('html').get(0);

        $(iframeHtml).on('click',function(e){

            APP.notes.createNote(e);

        });


        $(iframeHtml).on('click','.room-highlighted-text',function(){

            APP.main_canvas.removeHighlight($(this));

        });


    }

    function socketReady(){

        socket.bind_on_channel("highlight_web_resource_broadcast",receiveHighlight);

    }

    function displayHtml(html){

        var iframeHtml = $(frame).contents().find('html').get(0);
        iframeHtml.innerHTML = html;


    }

    function displayResource(res) {

        var frameDocument = $(frame).contents();
        var highlighter = frameDocument.getHighlighter();

        if (currentWebres != null) {

            currentWebres.highlight=highlighter.serializeHighlights()
            highlighter.removeHighlights();
            $(currentWebres.elem).removeClass("selected-web-resource");

        }

        displayHtml(res.html);

        if (res.highlight.length>0)
            highlighter.deserializeHighlights(res.highlight);

        currentWebres = res;
        $(currentWebres.elem).addClass("selected-web-resource");
        APP.notes.redraw();






    }

    function textHighlighted(){

        var frameDocument = $(frame).contents();
        var highlighter = frameDocument.getHighlighter();

        socket.trigger('room.web_resource_highlight',{
            room_id:room_id,
            resource_id:currentWebres.resource_id,
            highlight:highlighter.serializeHighlights()
        });

    }

    function receiveHighlight(msg){

        resources.resources[msg.resource_id].highlight=msg.highlight;

        if( currentWebres.resource_id== msg.resource_id ){

            var frameDocument = $(frame).contents();
            var highlighter = frameDocument.getHighlighter();
            highlighter.removeHighlights();
            highlighter.deserializeHighlights(msg.highlight);

        }

    }

    function isHighlightEnabled(){

        return highlightEnabled;

    }

    function removeHighlight(elem){

        if(highlightState == 2 ) {

            var frameDocument = $(frame).contents();
            var highlighter = frameDocument.getHighlighter();
            highlighter.removeHighlights(elem);
            textHighlighted();

        }

    }

    function showDefaultHtml(){

        displayHtml("<h1>Choose resource or add one!</h1>");

    }

    function resourceDeleted(id){

        if(currentWebres.resource_id == id){

            currentWebres = null;
            showDefaultHtml();

        }

    }

    function getCurrentResource(){

        return currentWebres;

    }

    return {

        textHighlighted:textHighlighted,
        displayResource:displayResource,
        displayHtml:displayHtml,
        init:init,
        isHighlightEnabled:isHighlightEnabled,
        removeHighlight:removeHighlight,
        resourceDeleted: resourceDeleted,
        getCurrentResource: getCurrentResource

    }


})(jQuery);