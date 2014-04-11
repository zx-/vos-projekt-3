/**
 * Created by z on 11.4.2014.
 */


var client = require('socket.io').listen(3001).sockets;

client.on('connection',function(socket){

    socket.on('chat-input',function(data){

        console.log(data);
        client.emit('output',data);

    })

    console.log(' New connection why u no work');

    socket.on('error', function (err) {
        console.log("Socket.IO Error");
        console.log(err.stack); // this is changed from your code in last comment
    });

})