/**
 * Created by z on 11.4.2014.
 */

var pg = require('pg');
var pg_server = 'postgres://vos2:123456@localhost:5432/vos-projekt-3_development';

var io_client = require('socket.io').listen(3001).sockets;

pg.connect(pg_server, function(err,pg_client,done){

    if(err) {
        return console.error('error fetching client from pool', err);
    }

    io_client.on('connection',function(socket){


        console.log("connected")

        socket.on('fetch-all-posts-request',function(data){

            console.log("fetch-all-posts-request");

            pg_client.query(

                'SELECT "userName" as "name","text" FROM chat_posts WHERE room=$1 ORDER BY "id" DESC LIMIT 15',
                [data.room],
                function(err,result){

                    if(!err){

                        socket.join('room-'+data.room)
                        socket.emit('fetch-all-posts-output',result.rows);
                        console.log('fetch-all-posts-output results rows')
                        console.log('socket joining: '+ 'room-'+data.room)
                        console.log(result.rows);

                    } else {

                        console.log(err);

                    }

                }

            );

        });


        socket.on('chat-input',function(data){

            console.log(data);

            if(!data.name.match(/^\s*$/) && !data.text.match(/^\s*$/)){

                socket.emit('output',data);
                socket.broadcast.to('room-'+data.room).emit('output',data);
                pg_client.query(
                    'INSERT INTO chat_posts ( "userName" , "text" , "room" ) VALUES($1,$2,$3)',
                    [data.name,data.text,data.room],
                    function (err, result) {
                        if(err) console.log(err);
                        //console.log(result);
                    }
                );

                console.log("Room logs: " +'room-'+data.room)
                //console.log(io_client.clients('room-'+data.room))

            }


        });

        console.log(' New connection why u no work');

        socket.on('error', function (err) {

            console.log("Socket.IO Error");
            console.log(err.stack); // this is changed from your code in last comment
            //done();

        });

        socket.on('disconnect',function(){

            //done();

        });

    });

});