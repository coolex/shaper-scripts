# info


# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.120.160  netmask 255.255.255.0  broadcast 192.168.120.255
        inet6 fe80::20c:29ff:fee8:fab3  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:e8:fa:b3  txqueuelen 1000  (Ethernet)
        RX packets 6022  bytes 591307 (577.4 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8482  bytes 2000462 (1.9 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.121.2  netmask 255.255.255.0  broadcast 192.168.121.255
        inet6 fe80::20c:29ff:fee8:fabd  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:e8:fa:bd  txqueuelen 1000  (Ethernet)
        RX packets 8385  bytes 11823477 (11.2 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4591  bytes 367632 (359.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.17.254.254  netmask 255.255.255.0  broadcast 10.17.254.255
        inet6 2001:67c:24f4:c001::1  prefixlen 128  scopeid 0x0<global>
        inet6 fe80::20c:29ff:fee8:fac7  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:e8:fa:c7  txqueuelen 1000  (Ethernet)
        RX packets 24  bytes 2208 (2.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 9  bytes 1106 (1.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

imq0: flags=193<UP,RUNNING,NOARP>  mtu 16000
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 11000  (UNSPEC)
        RX packets 24  bytes 1872 (1.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 24  bytes 1872 (1.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

imq1: flags=193<UP,RUNNING,NOARP>  mtu 16000
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 11000  (UNSPEC)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 0  (Local Loopback)
        RX packets 1  bytes 49 (49.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1  bytes 49 (49.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


# iptables -nvL
Chain INPUT (policy ACCEPT 6738 packets, 12M bytes)
 pkts bytes target     prot opt in     out     source               destination
 6023  482K ACCEPT     all  --  eth0   *       0.0.0.0/0            0.0.0.0/0

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  eth0   *       0.0.0.0/0            0.0.0.0/0
    0     0 DROP       all  --  *      eth0    0.0.0.0/0            0.0.0.0/0
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
    0     0 acl-ipv4-10.17.254-src  all  --  *      *       10.17.254.0/24       0.0.0.0/0

Chain OUTPUT (policy ACCEPT 12995 packets, 2036K bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain acl-ipv4-10.17.254-src (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     all  --  *      *       10.17.254.1          0.0.0.0/0
    0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0


# iptables -nvL -t nat
Chain PREROUTING (policy ACCEPT 94 packets, 13751 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain INPUT (policy ACCEPT 94 packets, 13751 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 35 packets, 2196 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
   35  2196 MASQUERADE  all  --  *      eth1    0.0.0.0/0            0.0.0.0/0

# iptables -nvL -t mangle
Chain PREROUTING (policy ACCEPT 13143 packets, 12M bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            match-set non-shape-igw-ipv4 dst
   33  2574 IMQ        all  --  eth2   *       0.0.0.0/0            0.0.0.0/0           IMQ: todev 0
    0     0 IMQ        all  --  vlan2  *       0.0.0.0/0            0.0.0.0/0           IMQ: todev 0
    0     0 IMQ        all  --  vlan300 *       0.0.0.0/0            0.0.0.0/0           IMQ: todev 0

Chain INPUT (policy ACCEPT 13143 packets, 12M bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 13307 packets, 2094K bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain POSTROUTING (policy ACCEPT 13307 packets, 2094K bytes)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            match-set non-shape-igw-ipv4 src
    0     0 IMQ        all  --  *      eth2    0.0.0.0/0            0.0.0.0/0           IMQ: todev 1
    0     0 IMQ        all  --  *      vlan2   0.0.0.0/0            0.0.0.0/0           IMQ: todev 1
    0     0 IMQ        all  --  *      vlan300  0.0.0.0/0            0.0.0.0/0           IMQ: todev 1

# tc qdisc
qdisc htb 1: dev imq0 root refcnt 2 r2q 10 default 2 direct_packets_stat 0 direct_qlen 11000
qdisc htb 1: dev imq1 root refcnt 2 r2q 10 default 2 direct_packets_stat 0 direct_qlen 11000
qdisc pfifo_fast 0: dev eth0 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
qdisc pfifo_fast 0: dev eth1 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
qdisc pfifo_fast 0: dev eth2 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1

# tc class show dev imq0
class htb 1:1 root rate 50Mbit ceil 50Mbit burst 1600b cburst 1600b
class htb 1:2 parent 1:1 prio 7 rate 1Kbit ceil 8Kbit burst 1600b cburst 1600b
class htb 1:a parent 1:5 prio 5 rate 1Kbit ceil 1Mbit burst 1600b cburst 1600b
class htb 1:5 parent 1:1 rate 1Kbit ceil 50Mbit burst 1600b cburst 1600b

# tc class show dev imq1
class htb 1:1 root rate 50Mbit ceil 50Mbit burst 1600b cburst 1600b
class htb 1:2 parent 1:1 prio 7 rate 1Kbit ceil 8Kbit burst 1600b cburst 1600b
class htb 1:a parent 1:5 prio 5 rate 1Kbit ceil 5Mbit burst 1600b cburst 1600b
class htb 1:5 parent 1:1 rate 1Kbit ceil 50Mbit burst 1600b cburst 1600b

# tc filter show dev imq0
filter parent 1: protocol ip pref 1 u32
filter parent 1: protocol ip pref 1 u32 fh 3: ht divisor 256
filter parent 1: protocol ip pref 1 u32 fh 3:1:800 order 2048 key ht 3 bkt 1 flowid 1:a
  match 0a11fe01/ffffffff at 12
filter parent 1: protocol ip pref 1 u32 fh 2: ht divisor 256
filter parent 1: protocol ip pref 1 u32 fh 2:fe:800 order 2048 key ht 2 bkt fe link 3:
  match 0a11fe00/ffffff00 at 12
    hash mask 000000ff at 12
filter parent 1: protocol ip pref 1 u32 fh 801: ht divisor 1
filter parent 1: protocol ip pref 5 u32
filter parent 1: protocol ip pref 5 u32 fh 802: ht divisor 1
filter parent 1: protocol ip pref 49152 u32
filter parent 1: protocol ip pref 49152 u32 fh 800: ht divisor 1
filter parent 1: protocol ip pref 49152 u32 fh 800::800 order 2048 key ht 800 bkt 0 link 2:
  match 0a110000/ffff0000 at 12
    hash mask 0000ff00 at 12

# tc filter show dev imq1
filter parent 1: protocol ip pref 1 u32
filter parent 1: protocol ip pref 1 u32 fh 3: ht divisor 256
filter parent 1: protocol ip pref 1 u32 fh 3:1:800 order 2048 key ht 3 bkt 1 flowid 1:a
  match 0a11fe01/ffffffff at 16
filter parent 1: protocol ip pref 1 u32 fh 2: ht divisor 256
filter parent 1: protocol ip pref 1 u32 fh 2:fe:800 order 2048 key ht 2 bkt fe link 3:
  match 0a11fe00/ffffff00 at 16
    hash mask 000000ff at 16
filter parent 1: protocol ip pref 1 u32 fh 801: ht divisor 1
filter parent 1: protocol ip pref 5 u32
filter parent 1: protocol ip pref 5 u32 fh 802: ht divisor 1
filter parent 1: protocol ip pref 49152 u32
filter parent 1: protocol ip pref 49152 u32 fh 800: ht divisor 1
filter parent 1: protocol ip pref 49152 u32 fh 800::800 order 2048 key ht 800 bkt 0 link 2:
  match 0a110000/ffff0000 at 16
    hash mask 0000ff00 at 16


