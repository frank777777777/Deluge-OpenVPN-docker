# yili/Deluge-OpenVPN
This images contains OpenVPN client and deluge. It enables your to torrent under OpenVPN without slowing down your host machine internet
![openvpn](https://github.com/frank777777777/Deluge-OpenVPN-docker/blob/master/images/OpenVPN.png?raw=true) ![deluge](https://github.com/frank777777777/Deluge-OpenVPN-docker/blob/master/images/Deluge.png?raw=true)
* Deluge is a lightweight, Free Software, cross-platform BitTorrent client. Full Encryption. Client-server model which makes it easier to remote access
* OpenVPN is an open-source software application that implements virtual private network (VPN) techniques to create secure point-to-point or site-to-site connections in routed or bridged configurations and remote access facilities.

### Features
* Works out of box, no extra configuration in dockerfile
* WebUI accessable from host machine
* Build-in killswitch, which shutdown internet within the the container if VPN connect fails
* Full Encryption
* Much more incoming...

## Build image

```$ git clone https://github.com/frank777777777/Deluge-OpenVPN-docker.git```
    copy yourOpenVPN.ovpn under the directory
```bash
$ docker build --build-arg vpnConfig=yourVPNConfig.ovpn . -t delugevpn:1.0 -f dockerfile
```

## Run image
```
$ docker run --privileged -d -p yourAvailablePortForWebUI:8112 -p yourAvailablePortForConsole:58846 -v yourHostDownloadDirectory:/root/downloads --name=delugeVPN delugevpn:1.0
```
Voilà! Now open your browser and enter localhost:yourAvailablePortForWebUI and start downloading

## Check your torrenting IP for the tracker
Copy the magnetic link from this website and check the ip
[ipmagnet](http://ipmagnet.services.cbcdn.com/)


## How to setup my OpenVPN server
1. Purchase a VPS server 
1. Use [Angristan/OpenVPN-install](https://github.com/Angristan/OpenVPN-install)

