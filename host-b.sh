export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo sysctl -w net.ipv4.ip_forward=1

# Startup commands for host-b go here

sudo ip addr add 192.168.4.42/25 dev enp0s8
sudo ip link set dev enp0s8 up

#route table

sudo ip route add 192.168.0.0/23 via 192.168.4.1
sudo ip route add 192.168.2.0/23 via 192.168.4.1
sudo ip route add 10.0.0.0/30 via 192.168.4.1