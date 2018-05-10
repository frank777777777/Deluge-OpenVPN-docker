FROM debian:jessie
MAINTAINER yili yxz163931@utdallas.edu
ARG vpnConfig

# 8112 for deluge-web, 58846 for local deluge-console
EXPOSE 8112 58846
VOLUME /data

ENV OPENVPN_CONFIG_PATH=/root/openvpnConfig/vpn.opvn
ENV DOWNLOAD_PATH=/root/download/

RUN mkdir -p /root/openvpnConfig/ \
    && mkdir -p /root/startupScript/ \
    && mkdir -p /root/download/
COPY $vpnConfig $OPENVPN_CONFIG_PATH

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install --no-install-recommends openvpn deluged deluge-web curl iptables -qy

RUN curl -fksSL https://raw.githubusercontent.com/frank777777777/Deluge-OpenVPN-docker/master/openVPNDeluge-startup.sh > /root/startupScript/openVPNDeluge-startup.sh \
    && curl -fksSL https://raw.githubusercontent.com/frank777777777/Deluge-OpenVPN-docker/master/killswitch.sh > /root/openvpnConfig/killswitch.sh 

RUN mkdir -p /root/startupScript/ \
    && chmod +x /root/startupScript/openVPNDeluge-startup.sh \
    && chmod +x /root/openvpnConfig/killswitch.sh

ENTRYPOINT exec sh -c /root/startupScript/openVPNDeluge-startup.sh

