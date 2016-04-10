2 (or more receivers) receivers

python simple_recv.py -a /my_address -m10

1 sender

python simple_send.py -a /my_address -m5

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       2   0    0     2        0
  mobile  my_address       0               2      0       0   0    0     0        0
  local   temp.OIKMkVYySr                  1      0       0   0    0     0        0

There are 2 local attached to /my_address : they are the two above receivers

Using "multiple" (standard configuration without "fixedAddress"), all receivers gets all the messages.
Ex. sender sent 5 messages

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       4   0    0     4        0
  mobile  my_address       0               2      0       5   10   0     0        0
  local   temp.XGspo3K5KJ                  1      0       0   0    0     0        0

There are 5 messages "in" the /my_address and 10 messages "out" : each message is sent twice (to each receiver).

Using "single" (with bias "closest" or "spread"), the messages are spread to receivers (one message per receiver)
Es. sender sent 5 messages

Router Addresses
  class   address          phase  in-proc  local  remote  in  out  thru  to-proc  from-proc
  ===========================================================================================
  local   $management             Y        0      0       0   0    0     0        0
  mobile  $management      0      Y        0      0       1   0    0     1        0
  mobile  my_address       0               2      0       5   5    0     0        0
  local   temp.uzvEHDuuMx                  1      0       0   0    0     0        0

There are 5 messages "in" the /my_address and 5 messages "out" : each message sent only one time (3 messages to a receiver, 2 messages to the other receiver)


