start Router B and it connects to the broker and listen for other routers to connect to it

A waypoint is created with internal addresses phase 0 and 1 and the only one consumer is now attached to the queue (broker)

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       1   0    0     1        0
  mobile  my_queue         0               1      0       0   0    0     0        0
  mobile  my_queue         1               0      0       0   0    0     0        0
  local   qdhello                 Y        0      0       0   0    0     0        6
  local   qdrouter                Y        0      0       0   0    0     0        1
  local   qdrouter.ma             Y        0      0       0   0    0     0        1
  local   temp.jr12hn8mlL                  1      0       0   0    0     0        0

The address phase 0 with local 1 is the destination to the queue (outgoing link).
We can see the "Number of Consumers" on the broker will be always 1 (even if I'll have more receivers attached to the routers).

There are other local address related to router protocol used by routers to :

- send HELLO message so that each router knows that the other router is online
- send updates for routing tables

start Router A and it connects to the Router B and listen for AMQP clients

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       2   0    0     2        0
  router  Router.B                         0      1       0   0    5     0        5
  mobile  my_queue         0               0      1       0   0    0     0        0
  local   qdhello                 Y        1      0       0   62   0     78       63
  local   qdrouter                Y        0      1       0   0    8     9        5
  local   qdrouter.ma             Y        0      1       0   0    0     1        0
  local   temp.MaUk4ZfIMh                  1      0       0   0    0     0        0

Same link route to the queue, same local address for routers communication and a Router.B address
shows the "remote" 1 conection to the Router.B.

Now the information on Router.B are changed due to Router.A connected :

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       1   0    0     1        0
  router  Router.A                         0      1       0   0    5     0        5
  mobile  my_queue         0               1      0       0   0    0     0        0
  mobile  my_queue         1               0      0       0   0    0     0        0
  local   qdhello                 Y        1      0       0   116  0     90       120
  local   qdrouter                Y        0      1       0   0    12    10       7
  local   qdrouter.ma             Y        0      1       0   0    0     1        1
  local   temp.fuCnPM8syv                  1      0       0   0    0     0        0

An entry to Router.A is added due to its connection.

Now a receiver starts and connects to the Router.A. On the broker there will be always 1 consumer on that queue.
NOTE : it's not the receiver but the waypoint on the Router.B

The sender starts and connects to the Router.A. it sends messages that are reveived by the above receiver.

We can put another receiver on Router.B and all messages sent by sender to the queue are then spread in
competing consumer fashion between receivers (on Router.A and Router.B).


