start Router B and it connects to the broker and listen for other routers to connect to it

Router Addresses
  class       address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===============================================================================================
  local       $management             Y        0      0       0   0    0     0        0
  mobile      $management      0      Y        0      0       1   0    0     1        0
  link-route  my_queue                         1      0       0   0    0     0        0
  local       qdhello                 Y        0      0       0   0    0     0        8
  local       qdrouter                Y        0      0       0   0    0     0        1
  local       qdrouter.ma             Y        0      0       0   0    0     0        1
  local       temp.3SHaZKK5k+                  1      0       0   0    0     0        0

There is the link route to the queue (broker) and local 1 means the container (broker) that will be destination
when senders will attach links on it.
There are other local address related to router protocol used by routers to :

- send HELLO message so that each router knows that the other router is online
- send updates for routing tables

start Router A and it connects to the Router B and listen for AMQP clients

Router Addresses
  class       address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===============================================================================================
  local       $management             Y        0      0       0   0    0     0        0
  mobile      $management      0      Y        0      0       1   0    0     1        0
  router      Router.B                         0      1       0   0    2     0        2
  link-route  my_queue                         0      0       0   0    0     0        0
  local       qdhello                 Y        1      0       0   1    0     2        3
  local       qdrouter                Y        0      1       0   0    0     3        1
  local       qdrouter.ma             Y        0      1       0   0    0     0        0
  local       temp.xswCjbbqj6                  1      0       0   0    0     0        0

Same link route to the queue, same local address for routers communication and a Router.B address
shows the "remote" 1 conection to the Router.B.

Now the information on Router.B are changed due to Router.A connected :

Router Addresses
  class       address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===============================================================================================
  local       $management             Y        0      0       0   0    0     0        0
  mobile      $management      0      Y        0      0       2   0    0     2        0
  router      Router.A                         0      1       0   0    5     0        5
  link-route  my_queue                         1      0       0   0    0     0        0
  local       qdhello                 Y        1      0       0   80   0     67       268
  local       qdrouter                Y        0      1       0   0    9     8        13
  local       qdrouter.ma             Y        0      1       0   0    0     1        1
  local       temp.DS4viiNCn9                  1      0       0   0    0     0        0

An entry to Router.A is added due to its connection.

Now a receiver starts and connects to the Router.A. On the broker there will be 1 consumer on that queue.
The link between receiver and queue (broker) through the two routers is established.

The sender starts and connects to the Router.A. It establish a link to the queue (broker) through the two router
and sends messages that are reveived by the above receiver.

We can put another receiver on Router.B and all messages sent by sender to the queue are then spread in
competing consumer fashio between receivers (on Router.A and Router.B).
