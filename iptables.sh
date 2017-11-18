#!/bin/bash

# delete all existing rules
iptables -F
iptables -X
ip6tables -F
ip6tables -X

# basic rules
iptables -N TCP
iptables -N UDP
ip6tables -N TCP
ip6tables -N UDP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT
ip6tables -P INPUT DROP

# keep existing connections
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT

# drop all traffic with "INVALID" state
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP

# allow new incomming ping requests
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type 128 -m conntrack --ctstate NEW -j ACCEPT

# open ports for ssh, bitcoin etc.
# !!! ADAPT TO YOU LOCAL NETWORK SETUP !!!
iptables -A TCP -p tcp --dport 22 -j ACCEPT
iptables -A TCP -p tcp --dport 8333 -j ACCEPT
iptables -A TCP -p tcp --sport 8333 -j ACCEPT
ip6tables -A TCP -p tcp --dport 8333 -j ACCEPT
ip6tables -A TCP -p tcp --sport 8333 -j ACCEPT

# handle all new incomming connections for tcp and udp
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
ip6tables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP

# reject tcp and udp connections if the port is not open
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-rst
ip6tables -A INPUT -p udp -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A INPUT -p tcp -j REJECT

# reject all other connections
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable
ip6tables -A INPUT -j REJECT --reject-with icmp6-adm-prohibited

# save the firewall rules
iptables-save > /etc/iptables/iptables.rules
ip6tables-save > /etc/iptables/ip6tables.rules

echo -------------------------
echo Job Finished
read -n1 -r -p "Press any key to continue..." key
