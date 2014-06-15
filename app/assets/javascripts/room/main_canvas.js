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

    function init(sckt,r_id,res,frm){

        resources = res;
        socket = sckt;
        room_id = r_id;
        frame =  frm;
        doc  = frame[0].contentWindow.document;
        body = $('body',doc);

        displayHtml("<h1>Choose resource or add one!</h1>");

        var initializeTextHighlighter = function() {
            var frameDocument = $(frame).contents();
            frameDocument.textHighlighter({
                onAfterHighlight: function(highlights, range) {
                    APP.main_canvas.textHighlighted();
                },
                onBeforeHighlight:function(range){
                    return APP.main_canvas.isHighlightEnabled();
                }
            });
        };

        $(frame).load(initializeTextHighlighter);  // Non-IE
        $(frame).ready(initializeTextHighlighter); // IE

        socket.bind_on_channel("highlight_web_resource_broadcast",receiveHighlight);

        $("#room-highlight-controls").click(function(){

            highlightEnabled = !highlightEnabled;

            if(highlightEnabled)
                $(this).find('span').find('span').html("enabled");
            else
                $(this).find('span').find('span').html("disabled");

        })

    }

    function displayHtml(html){

        var iframeHtml = $(frame).contents().find('html').get(0);
        iframeHtml.innerHTML = html;

    }

    function displayResource(res) {

        var frameDocument = $(frame).contents();
        var highlighter = frameDocument.getHighlighter();

        if (currentWebres != null) {

            currentWebres.highlights=highlighter.serializeHighlights()
            highlighter.removeHighlights();
            $(currentWebres.elem).removeClass("selected-web-resource");

        }
        displayHtml(res.html);
        if (res.highlights.length>0)
            highlighter.deserializeHighlights(res.highlights);

        currentWebres = res;
        $(currentWebres.elem).addClass("selected-web-resource");


    }

    function textHighlighted(){

        var frameDocument = $(frame).contents();
        var highlighter = frameDocument.getHighlighter();

        socket.trigger('room.web_resource_highlight',{
            room_id:room_id,
            resource_id:currentWebres.resource_id,
            highlights:highlighter.serializeHighlights()
        });

    }

    function receiveHighlight(msg){

        resources.resources[msg.resource_id].highlights=msg.highlights;

        if( currentWebres.resource_id== msg.resource_id ){

            var frameDocument = $(frame).contents();
            var highlighter = frameDocument.getHighlighter();
            highlighter.removeHighlights();
            highlighter.deserializeHighlights(msg.highlights);

        }

    }

    function isHighlightEnabled(){

        return highlightEnabled;

    }

    return {

        textHighlighted:textHighlighted,
        displayResource:displayResource,
        displayHtml:displayHtml,
        init:init,
        isHighlightEnabled:isHighlightEnabled

    }


})(jQuery);