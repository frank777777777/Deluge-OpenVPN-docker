nohup openvpn --config ${OPENVPN_CONFIG_PATH} 1>/dev/null &
echo "nameserver 1.1.1.1" > /etc/resolv.conf
nohup /root/openvpnConfig/killswitch.sh ${OPENVPN_CONFIG_PATH} &
deluged
deluge-web -c /root/.config/deluge/
