/**
 * Created by z on 14.6.2014.
 */
/*


    web_res :{
        id,html,title,image_url,user_id,user_name
    }

 */
function WebResourcesPanel(socket,room_id,container){

    this.resources = [];
    this.button = {};
    this.room_id = room_id;
    this.socket = socket;
    this.container = container;
    this.input = {};
    this.status = {};

    this.url_pattern = /\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[{};:'".,<>?«»“”‘’]|\]|\?))/ig

    this.init = function(){

        //add_web_resource_broadcast
        //add_web_resource
        this.button = $(this.container).find("#resource-add-button");
        this.input = $(this.container).find("#resource-input-url");
        this.status = $(this.container).find("#resource-input-status");

        this.input_ready(false)

        this.socket.on_successful_connection(this.ready.bind(this));

    }

    this.input_ready = function(bol,msg){

        $(this.button).prop("disabled",!bol);
        $(this.input).prop("disabled",!bol);
        $(this.status).html(msg);

    }

    this.ready = function(){

        var incRes = this.incoming_web_resource.bind(this);
        var resConf = this.web_resource_confirmation.bind(this);

        this.socket.bind_on_dispatcher("add_web_resource_confirmation",resConf);
        this.socket.bind_on_channel("add_web_resource_broadcast",incRes);

        this.input_ready(true,"ready");

        $(this.button).click(this.button_clicked.bind(this))

    }

    this.button_clicked = function(){

        console.log("Clickeled")
        console.log($(this.input).val())

        var url = $(this.input).val();

        if ( this.url_pattern.test(url) ){

            APP.messages.showSuccess("Url is being processed",2500)
            $(this.input).val("")
            this.input_ready(false,"processing resource");
            this.socket.trigger('room.add_web_resource', {room_id:room_id,url:url})

        } else {

            APP.messages.showAlert("Bad resource url",2500);

        }

    }

    this.incoming_web_resource = function(data){

        console.log("web_res_broadcast")
        console.log(data);
        APP.messages.showInfo("New resource "+data.url+" added",2500)


    }
    this.web_resource_confirmation = function(data){

        console.log("web_res_confirmation")
        console.log(data);

        if(data.success){

            this.input_ready(true,"ready")

        } else {

            this.input_ready(true,"ready")
            APP.messages.showAlert("Resource could not be added",2500)

        }

    }

    this.add_resource = function(data,htmlElement){

        this.resources[data.resource_id]={data:data,htmlElement:htmlElement}

    }

    this.generateHtmlObj = function(data){

        return $(
            "<li data-obj-id="+data.resource_id+">"+
                "<img src='"+data.image_url+"' alt="+data.title+"></img>"+
                "<h5>"+data.title+"</h5>"+
                "<h5>"+data.user_name+"</h5>"+
            "</li>"
        )

    }


    this.init();

}