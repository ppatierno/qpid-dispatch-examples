2 (or more receivers) receivers

python simple_recv.py -a /my_address -m10

1 sender

python simple_send.py -a /my_address -m10

Router Links
  type      dir  id  peer  class   addr                  phs  cap  undel  unsettled  deliveries  admin    oper
  ==============================================================================================================
  endpoint  out  8         mobile  my_address            0    250  0      0          0           enabled  up
  endpoint  out  9         mobile  my_address            0    250  0      0          0           enabled  up
  endpoint  in   10        mobile  $management           0    250  0      0          1           enabled  up
  endpoint  out  11        local   temp.74KU0kDgOHDaU8+       250  0      0          0           enabled  up

There are 2 endpoint for my_address (as output, from a router point of view) : they are the two above receivers

Using "balanced" (standard configuration without "address"), messages are spread along receivers, in a "competing consumer" fashion
Ex. sender sent 5 messages

Router Links
  type      dir  id  peer  class   addr                  phs  cap  undel  unsettled  deliveries  admin    oper
  ==============================================================================================================
  endpoint  out  8         mobile  my_address            0    250  0      0          3           enabled  up
  endpoint  out  9         mobile  my_address            0    250  0      0          2           enabled  up
  endpoint  in   13        mobile  $management           0    250  0      0          1           enabled  up
  endpoint  out  14        local   temp.85k4ahsuHUpfQwu       250  0      0          0           enabled  up

Thre are 3 messages delivered to one endpoint and the other 2 to the other endpoint.
Using "closest" as distribution doesn't change anything becase the two endpoint are connected to the same router
so are "closed" at same level.

Using distribution "multicast", all messages are sent to all receivers.

Router Links
  type      dir  id  peer  class   addr                  phs  cap  undel  unsettled  deliveries  admin    oper
  ==============================================================================================================
  endpoint  out  4         mobile  my_address            0    250  0      0          5           enabled  up
  endpoint  out  5         mobile  my_address            0    250  0      0          5           enabled  up
  endpoint  in   7         mobile  $management           0    250  0      0          1           enabled  up
  endpoint  out  8         local   temp.Aes_4LlwCftfIiY       250  0      0          0           enabled  up


There are 5 messages delivered to both endpoints.


