1 receiver

python simple_recv.py -a /my_queue -m1

1 sender

python simple_send.py -a /my_queue -m1

The router connects to the broker and open two links (sender and receiver) to the queue

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       1   0    0     1        0
  mobile  my_queue         0               1      0       0   0    0     0        0
  mobile  my_queue         1               0      0       0   0    0     0        0
  local   temp.hoem9hMes9                  1      0       0   0    0     0        0

The local 1 at address with phase 0 is related to the outgoing link from router to the queue (a destination). 

The receiver connectes to the router and an AMQP link is created with the router.
It showed as a local 1 on address phase 1.

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       2   0    0     2        0
  mobile  my_queue         0               1      0       0   0    0     0        0
  mobile  my_queue         1               1      0       0   0    0     0        0
  local   temp.X5s9L2ZlHu                  1      0       0   0    0     0        0

The sender connectes to the router and an AMQP link (2) is created with the router.
The message goes to address phase 0 and then from the router to the queue (in the broker).
The router gets the message from the broker using the address phase 1 and then sends it to the receiver.

Following if sender sends 5 messages :

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       3   0    0     3        0
  mobile  my_queue         0               1      0       5   5    0     0        0
  mobile  my_queue         1               1      0       0   5    0     0        0
  local   temp.PZMSKRDvJu                  1      0       0   0    0     0        0

Using more than one receiver and a sender which sends more messages :
Attached to the queue (broker) there is always only one consumer (i.e. "Number of Consumers" in ActiveMQ). It's the internal one inside the router.
The internal router receiver gets messages from the broker and spreads messages on the receivers (one message per receiver) in a "competing consumer" fashion
(it's like to have consumers directly connected to the broker on a same queue that is different from topic/subscriptions, so no pub/sub)

NOTE (about make a queue like pub/sub) :

We can change the fanout to "multiple" of address phase 1 (output to receivers) in the following way :

fixedAddress {
    prefix: my_queue
    phase: 1
    fanout: multiple
    bias: closest
}

In that case the internal router gets messages from queue (broker) and then sends them to all receivers in a multicast way.
We have changed the "competing consumer" pattern of a queue on a broker in "pub/sub" of a topic/subscription.

NOTE (about using server) : 

We can use same example with an AMQP server instead of broker.
We don't deal with queue/topic but with sender/receiver created "on-fly" by the AMQP server
when a receiver/sender connects to it.

