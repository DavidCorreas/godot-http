#!/bin/sh
echo "$VPN_USERNAME" > /etc/openvpn/client/auth.txt
echo "$VPN_PASSWORD" >> /etc/openvpn/client/auth.txt
openvpn --config /etc/openvpn/client/client.ovpn --auth-user-pass /etc/openvpn/client/auth.txt