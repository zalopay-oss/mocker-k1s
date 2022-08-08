delete() {

}

create() {
  id=$1

  ip netns add $1
}

link() {
  netns_0=$1
  netns_1=$2
  # all previous configurations were deleted
  # creating a pair of namespaces
  ip netns add $netns_0
  ip netns add $netns_1
  tree /var/run/netns/
  # /var/run/netns/
  # ├── $netns_0
  # └── $netns_1
  # ...
  ip link add veth0 type veth peer name ceth0
  ip link add veth1 type veth peer name ceth1
  ip link set veth1 up
  ip link set veth0 up
  ip link set ceth0 netns $netns_0
  ip link set ceth1 netns $netns_1
  # setup the first connected interface -> net_namespace=$netns_0
  ip netns exec $netns_0 ip link set lo up
  ip netns exec $netns_0 ip link set ceth0 up
  ip netns exec $netns_0 ip addr add 192.168.1.20/24 dev ceth0

  # setup the second connected interface -> $netns_1
  ip netns exec $netns_1 ip link set lo up
  ip netns exec $netns_1 ip link set ceth1 up
  ip netns exec $netns_1 ip addr add 192.168.1.21/24 dev ceth1

  # create the bridge
  ip link add name br0 type bridge
  # set an ip on the bridge and turn it up
  # so that processes can reach the LAN through it
  ip addr add 192.168.1.11/24 brd + dev br0
  ip link set br0 up
  # connect the ends of the network namespaces in the
  # root namespace to the bridge
  ip link set veth0 master br0
  ip link set veth1 master br0
  # check if the bridge is the master of the two veths
  bridge link show br0
  # 10: veth0@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2
  # 12: veth1@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2

  # allow forwarding by the bridge in the root net namespace
  # in order to enable the interface to forward between the namespaces
  # depending on the different iptables policy this step may be skipped
  iptables -A FORWARD -i br0 -j ACCEPT

  # check the network connection netns_test1 -> netns_test0
  ip netns exec netns_test1 ping  192.168.1.20
  # PING 192.168.1.20 (192.168.1.20) 56(84) bytes of data.
  # 64 bytes from 192.168.1.20: icmp_seq=1 ttl=64 time=0.046 ms
  # ...

  # connectivity check root_namespace -> $netns_0
  ip route
  # ...
  # 192.168.1.0/24 dev br0 proto kernel scope link src 192.168.1.11
  # ...
  # ping 192.168.1.20
  # PING 192.168.1.20 (192.168.1.20) 56(84) bytes of data.
  # 64 bytes from 192.168.1.20: icmp_seq=1 ttl=64 time=0.150 ms
  # ...

  # # check the network connection netns_test0 -> netns_test1
  # ip netns exec netns_test0 ping 192.168.1.21
  # PING 192.168.1.21 (192.168.1.21) 56(84) bytes of data.
  # 64 bytes from 192.168.1.21: icmp_seq=1 ttl=64 time=0.040 ms
  # ...
}
