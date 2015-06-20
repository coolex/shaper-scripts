#!/bin/bash

ip link set imq0 up
ip link set imq1 up
tc qdisc add dev imq0 root handle 1: htb default 2
tc qdisc add dev imq1 root handle 1: htb default 2
tc filter add dev imq0 parent 1: protocol ip u32
tc filter add dev imq1 parent 1: protocol ip u32
tc class add dev imq0 parent 1: classid 1:1 htb rate 50Mbit
tc class add dev imq1 parent 1: classid 1:1 htb rate 50Mbit
tc class add dev imq0 parent 1:1 classid 1:2 htb rate 1Kbit ceil 8Kbit prio 8 quantum 1514
tc class add dev imq1 parent 1:1 classid 1:2 htb rate 1Kbit ceil 8Kbit prio 8 quantum 1514

tc class add dev imq0 parent 1:1 classid 1:5 htb rate 1Kbit ceil 50Mbit prio 5 quantum 1515
tc class add dev imq1 parent 1:1 classid 1:5 htb rate 1Kbit ceil 50Mbit prio 5 quantum 1515
tc class add dev imq0 parent 1:5 classid 1:a htb rate 1Kbit ceil 1Mbit prio 5 quantum 1515
tc class add dev imq1 parent 1:5 classid 1:a htb rate 1Kbit ceil 5Mbit prio 5 quantum 1515

tc filter add dev imq0 parent 1: protocol ip prio 1 handle 2: u32 divisor 256
tc filter add dev imq1 parent 1: protocol ip prio 1 handle 2: u32 divisor 256
tc filter add dev imq0 protocol ip parent 1: prio 1 u32 ht 800:: match ip src 10.17.0.0/16 hashkey mask 0x0000ff00 at 12 link 2:
tc filter add dev imq1 protocol ip parent 1: prio 1 u32 ht 800:: match ip dst 10.17.0.0/16 hashkey mask 0x0000ff00 at 16 link 2:
tc filter add dev imq0 parent 1: protocol ip prio 1 handle 3: u32 divisor 256
tc filter add dev imq1 parent 1: protocol ip prio 1 handle 3: u32 divisor 256
tc filter add dev imq0 protocol ip parent 1: prio 1 u32 ht 2:fe match ip src 10.17.254.0/24 hashkey mask 0x000000ff at 12 link 3:
tc filter add dev imq1 protocol ip parent 1: prio 1 u32 ht 2:fe match ip dst 10.17.254.0/24 hashkey mask 0x000000ff at 16 link 3:
iptables -N acl-ipv4-10.17.254-src
iptables -A FORWARD -s 10.17.254.0/24 -j acl-ipv4-10.17.254-src
iptables -A acl-ipv4-10.17.254-src -j DROP

tc filter add dev imq0 protocol ip parent 1: prio 5 u32 ht 3:1: match ip src 10.17.254.1/32 flowid 1:a
tc filter add dev imq1 protocol ip parent 1: prio 5 u32 ht 3:1: match ip dst 10.17.254.1/32 flowid 1:a
iptables -I acl-ipv4-10.17.254-src -s 10.17.254.1 -j ACCEPT

