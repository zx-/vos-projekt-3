/**
 * Created by z on 14.6.2014.
 */
var APP = APP || {};

APP.main_canvas = (function($){

    var frame;
    var body;
    var doc;

    function init(frm){

        frame =  frm;
        doc  = frame[0].contentWindow.document;
        body = $('body',doc);

    }

    function displayHtml(html){

        body.html(html);

    }

    return {

        displayHtml:displayHtml,
        init:init

    }


})(jQuery);