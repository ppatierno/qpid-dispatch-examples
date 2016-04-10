1 receiver

python simple_recv.py -a /my_queue -m1

1 sender

python simple_send.py -a /my_queue -m1

The router connects to the broker and a link-route entry is created (only TCP connection, no AMQP links between router and broker)

Router Addresses
  class       address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===============================================================================================
  local       $management             Y        0      0       0   0    0     0        0
  mobile      $management      0      Y        0      0       4   0    0     4        0
  link-route  my_queue                         1      0       0   0    0     0        0
  local       temp.2C4jiAy_4V                  1      0       0   0    0     0        0

The receiver connectes to the router and an AMQP link (1) is created directly with the broker on the "my_queue".
The sender connectes to the router and an AMQP link (2) is created directly with the broker on the "my_queue".
The sender sends a message on that AMQP link (2) and it goes into the queue.
Using the AMQP link (1) the receiver gets the message from that queue.

The router passes message from one side to another internally (no links with clients).

Router Addresses
  class       address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===============================================================================================
  local       $management             Y        0      0       0   0    0     0        0
  mobile      $management      0      Y        0      0       5   0    0     5        0
  link-route  my_queue                         1      0       0   0    0     0        0
  local       temp.awf5FfM3Eb                  1      0       0   0    0     0        0

The "in" and "out" on link-route "my_queue" is always 0.

Using more than one receiver and a sender which sends more messages :
the broker spreads messages on the receivers (one message per receiver) in a "competing consumer" fashion
(it's like to have consumers directly connected to the broker on a same queue that is different from topic/subscriptions, so no pub/sub)

NOTE (about broker) :

Using the broker console (i.e. ActiveMQ web console) we can see that the "Number of Consumers" is exacty the number of receivers
(different from using "waypoint", only one consumer per connected router)

NOTE (about using server) : 

We can use same example with an AMQP server instead of broker.
We don't deal with queue/topic but with sender/receiver created "on-fly" by the AMQP server
when a receiver/sender connects to it.

