export DEBIAN_FRONTEND=noninteractive
apt-get update
sudo sysctl -w net.ipv4.ip_forward=1
# Startup commands for router-2 go here

sudo ip addr add 10.0.0.2/30 dev enp0s9
sudo ip addr add 192.168.2.1/23 dev enp0s8
sudo ip link set dev enp0s9 up
sudo ip link set dev enp0s8 up

#route table
sudo ip route add 192.168.0.0/23 via 10.0.0.1
sudo ip route add 192.168.4.0/25 via 10.0.0.1


