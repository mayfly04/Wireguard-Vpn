# Wireguard-Vpn

ssh root@xxx.xxx.x.xx

wget https://raw.githubusercontent.com/drew2a/wireguard/master/wg-ubuntu-server-up.sh
or(Below is a backup. Always use the above one.Master script)
wget https://github.com/mayfly04/Wireguard-Vpn/blob/master/wg-ububtu-server-up.sh


chmod +x ./wg-ububtu-server-up.sh

sudo ./wg-ububtu-server-up.sh 5 


Add this to the client config before connecting on mango router, Especially MTU value.

MTU = 1280
PostUp = ip route add SERVER_PUBLIC_IP/32 via 192.168.8.1 dev eth0; iptables -A FORWARD -i wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT; iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
PostDown = ip route del SERVER_PUBLIC_IP/32 via 192.168.8.1 dev eth0; iptables -D FORWARD -i wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT; iptables -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu



**********************Debian OS example

https://github.com/drew2a/wireguard

wget https://raw.githubusercontent.com/drew2a/wireguard/master/wg-debian-server-up.sh

chmod +x ./wg-debian-server-up.sh
sudo ./wg-debian-server-up.sh
