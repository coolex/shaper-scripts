#!/bin/bash

ACTION=$1

if [ "$ACTION" = "start" ]; then

# DROP Packet forward to MGT
iptables -A FORWARD -i eth0 -j DROP
ip6tables -A FORWARD -i eth0 -j DROP
iptables -A FORWARD -o eth0 -j DROP
ip6tables -A FORWARD -o eth0 -j DROP
iptables -A INPUT -i eth0 -j ACCEPT
ip6tables -A INPUT -i eth0 -j ACCEPT

# RELATED a ESTABLISHED
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Maskarada
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Spust SHAPER
/opt/shaper/shaper.sh

ipset create non-shape-igw-ipv4 hash:net
ipset create non-shape-igw-ipv6 hash:net family inet6
iptables -t mangle -A PREROUTING -m set --match-set non-shape-igw-ipv4 dst -j ACCEPT
iptables -t mangle -A POSTROUTING -m set --match-set non-shape-igw-ipv4 src -j ACCEPT
ip6tables -t mangle -A PREROUTING -m set --match-set non-shape-igw-ipv6 dst -j ACCEPT
ip6tables -t mangle -A POSTROUTING -m set --match-set non-shape-igw-ipv6 src -j ACCEPT
# IP primo na IGW nebudou shapovany
ipset add non-shape-igw-ipv4 194.8.252.1
ipset add non-shape-igw-ipv4 194.8.253.225
ipset add non-shape-igw-ipv6 2001:67c:24f4:accd::1 
ipset add non-shape-igw-ipv6 2001:67c:24f4:acdc::1

# Presmerovat vsechen traffic do IMQ
iptables -t mangle -A PREROUTING -i eth2 -j IMQ --todev 0
iptables -t mangle -A POSTROUTING -o eth2 -j IMQ --todev 1
ip6tables -t mangle -A PREROUTING -i eth2 -j IMQ --todev 0
ip6tables -t mangle -A POSTROUTING -o eth2 -j IMQ --todev 1
iptables -t mangle -A PREROUTING -i vlan2 -j IMQ --todev 0
iptables -t mangle -A POSTROUTING -o vlan2 -j IMQ --todev 1
ip6tables -t mangle -A PREROUTING -i vlan2 -j IMQ --todev 0
ip6tables -t mangle -A POSTROUTING -o vlan2 -j IMQ --todev 1
iptables -t mangle -A PREROUTING -i vlan300 -j IMQ --todev 0
iptables -t mangle -A POSTROUTING -o vlan300 -j IMQ --todev 1
ip6tables -t mangle -A PREROUTING -i vlan300 -j IMQ --todev 0
ip6tables -t mangle -A POSTROUTING -o vlan300 -j IMQ --todev 1

# Co neni povolene, je zakazana
iptables -P INPUT ACCEPT
ip6tables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
ip6tables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
ip6tables -P FORWARD ACCEPT

fi


if [ "$ACTION" = "stop" ]; then

# Povolit vse
iptables -P INPUT ACCEPT
ip6tables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
ip6tables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
ip6tables -P FORWARD ACCEPT

# SMAZAT vse
iptables -t mangle -F
ip6tables -t mangle -F
iptables -t nat -F
#ip6tables -t nat -F
iptables -F
ip6tables -F

ipset destroy

iptables -t mangle -X
ip6tables -t mangle -X
iptables -t nat -X
#ip6tables -t nat -X
iptables -X
ip6tables -X

tc qdisc del dev imq0 root 2> /dev/null
tc qdisc del dev imq1 root 2> /dev/null
ip link set imq0 down
ip link set imq1 down

fi

if [ "$ACTION" = "stop-shaper" ]; then

# Povolit vse
iptables -P FORWARD ACCEPT
ip6tables -P FORWARD ACCEPT

# SMAZAT vse
iptables -t mangle -F
iptables -t mangle -X

tc qdisc del dev imq0 root 2> /dev/null
tc qdisc del dev imq1 root 2> /dev/null
ip link set imq0 down
ip link set imq1 down

fi

if [ "$ACTION" = "" ]; then
	echo "Pouzitelne prikazy jsou: start | stop | stop-shaper"
fi


