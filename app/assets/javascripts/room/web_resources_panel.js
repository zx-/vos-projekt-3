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
    this.resource_list = {};
    this.input = {};
    this.status = {};
    this.user_id;

    this.url_pattern = /\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[{};:'".,<>?«»“”‘’]|\]|\?))/ig

    this.init = function(){

        //add_web_resource_broadcast
        //add_web_resource
        this.button = $(this.container).find("#resource-add-button");
        this.input = $(this.container).find("#resource-input-url");
        this.status = $(this.container).find("#resource-input-status");
        this.resource_list = $(this.container).find("ul");


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
        var resList = this.web_resource_list.bind(this);
        var rmRes = this.remove_web_resource.bind(this);

        this.user_id = this.socket.getUserId();

        this.socket.bind_on_dispatcher("add_web_resource_confirmation",resConf);
        this.socket.bind_on_channel("add_web_resource_broadcast",incRes);
        this.socket.bind_on_dispatcher("list_all_resources_response",resList);
        this.socket.bind_on_channel("remove_web_resource_broadcast",rmRes);

        this.socket.trigger('room.list_all_resources', {room_id:this.room_id})

        this.input_ready(true,"ready");

        $(this.button).click(this.button_clicked.bind(this))

    }

    this.button_clicked = function(){

        console.log("Clickeled")
        console.log($(this.input).val())

        var url = $(this.input).val();
        this.url_pattern.lastIndex = 0;

        if ( this.url_pattern.test(url) ){

            APP.messages.showInfo("Url is being processed",2500)
            $(this.input).val("")
            this.input_ready(false,"processing resource");
            this.socket.trigger('room.add_web_resource', {room_id:this.room_id,url:url})

        } else {

            if(url!="")
                APP.messages.showAlert("Bad resource url",2500);

        }

    }

    this.remove_web_resource = function(data){

        if(this.resources[data.resource_id]) {

            APP.messages.showInfo(this.resources[data.resource_id].title+" was removed from resource list",2500);
            delete this.resources[data.resource_id];
            APP.main_canvas.resourceDeleted(data.resource_id);
            $(this.resource_list).find("[data-obj-id="+data.resource_id+"]").remove();

        }

    }

    this.incoming_web_resource = function(data){

        console.log("web_res_broadcast")
        console.log(data);
        APP.messages.showInfo("New resource "+data.url+" added",2500)
        this.add_resource(data);

    }
    this.web_resource_list = function(data){

        console.log(data)
        for(var i = 0; i<data.data.length; i++)
            this.add_resource(data.data[i]);

        APP.main_canvas.displayResource(this.resources[data.data[0].resource_id])

    }

    this.web_resource_confirmation = function(data){

        console.log("web_res_confirmation")
        console.log(data);

        if(data.success){

            this.input_ready(true,"ready")

        } else {

            this.input_ready(true,"ready")
            APP.messages.showAlert(data.message,2500)

        }

    }

    this.add_resource = function(data){

        this.resources[data.resource_id]=data;
        var o = this.generateHtmlObj(data);
        this.resources[data.resource_id].elem = o;

        $(this.resource_list).append(o);
        var func = this.res_clicked.bind(this);
        $(o).click(function(){func(data.resource_id);})


    }

    this.res_clicked = function(id){

        APP.main_canvas.displayResource(this.resources[id])

    }

    this.generateHtmlObj = function(data){

        var a =$(
                "<li data-obj-id="+data.resource_id+">"+
                "<img src='"+data.image_url+"' alt="+data.title+" class='resource_image'></img>"+
                "<h5><strong>"+data.title+"</strong></h5>"+
                "<p>Added by '"+data.user_name+"'</p>"+
                "</li>"
        );

        if(data.user_id == this.user_id){

            var f =  function(event,res_id){

                event.stopPropagation();
                console.log("delete");
                APP.socket.trigger('room.remove_web_resource',{

                    room_id:this.room_id,
                    resource_id:res_id

                });

            }.bind(this);

            var but = $("<span></span>",{
                class:'glyphicon glyphicon-remove',
                click:function(event){ f(event,data.resource_id)}
            });

            but.appendTo(a);

        }

        return a;

    }


    this.init();

}