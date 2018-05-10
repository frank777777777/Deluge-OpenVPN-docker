#!/bin/bash
trap ctrl_c INT
VPN_FILE=$1

function check_permission() {
	if test " `id -u`" != " 0"
		then
		echo "permission denied (use sudo)"
		exit 1
	fi
}

function check_argument() {
	if [ -z $VPN_FILE ]
		then
		echo "First argument must be VPN file(.ovpn)"
		exit 1
	fi
}

function config() {	
	#Get the default network interface
	echo "Detecting your default network interface..."
	INTERFACE=`ip addr | grep "state UP" | cut -d ":" -f 2 | head -n 1 | cut -d "@" -f 1`
	echo "Using "$INTERFACE

	TUNNEL=tun0
	echo "Using interface "$TUNNEL " for VPN, change the script if you need another one."	

	#Get the VPN IP, PORT and PROTOCOL from the VPN file
	echo "Detecting your VPN server address..."
	IP=`cat $VPN_FILE | grep "remote " | awk '{print $2}'`
	echo "Using IP "$IP

	echo "Detecting your VPN port..."
	PORT=`cat $VPN_FILE | grep "remote " | awk '{print $3}'`
	echo "Using port "$PORT

	echo "Detecting your VPN protocol..."
	PROTOCOL=`cat $VPN_FILE | grep "proto " | awk '{print $2}'`
	echo "Using protocol "$PROTOCOL
}

function ctrl_c() {
	echo "Flushing iptables and exiting"
	iptables --flush
	exit 1
}

function set_firewall_rules() {
	echo "Setting firewall rules"
	iptables --flush
	#Allow connection with the VPN IP
	iptables -A OUTPUT -p $PROTOCOL -d $IP --dport $PORT -j ACCEPT
	iptables -A INPUT -p $PROTOCOL -s $IP --sport $PORT -j ACCEPT
	#Allow connection through the tunnel
	iptables -A OUTPUT -o $TUNNEL -j ACCEPT
	iptables -A INPUT -i $TUNNEL -j ACCEPT
	#allow deluge-service
	iptables -A OUTPUT -p tcp --sport 8112 -j ACCEPT
	iptables -A INPUT -p tcp --dport 8112 -j ACCEPT
        iptables -A OUTPUT -p tcp --sport 58846 -j ACCEPT
	iptables -A INPUT -p tcp --dport 58846 -j ACCEPT
	#allow ssh port 22
	iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT
	#allow dns
	iptables -A INPUT -p udp --sport 53 -j ACCEPT
	iptables -A INPUT -p udp --dport 53 -j ACCEPT
	iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
	iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
	
	#Block all connection through the main interface
	iptables -A OUTPUT -o $INTERFACE -j DROP
	iptables -A INPUT -i $INTERFACE -j DROP
}


check_permission
check_argument
config
set_firewall_rules
