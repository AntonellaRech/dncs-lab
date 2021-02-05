export DEBIAN_FRONTEND=noninteractive
apt-get update
sudo sysctl -w net.ipv4.ip_forward=1

# Startup commands for host-a go here

sudo ip addr add 192.168.0.65/23 dev enp0s8
sudo ip link set dev enp0s8 up

#route table gateway

sudo ip route add 192.168.4.0/25 via 192.168.0.1
sudo ip route add 10.0.0.0/30 via 192.168.0.1
sudo ip route add 192.168.2.0/23 via 192.168.0.1