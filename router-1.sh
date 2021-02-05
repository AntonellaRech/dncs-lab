export DEBIAN_FRONTEND=noninteractive
apt-get update
sudo sysctl -w net.ipv4.ip_forward=1

# Startup commands for router-1 go here

sudo ip addr add 10.0.0.1/30 dev enp0s9
sudo ip link add link enp0s8 name enp0s8.1 type vlan id 1
sudo ip link add link enp0s8 name enp0s8.2 type vlan id 2
sudo ip addr add 192.168.0.1/23 dev enp0s8.1
sudo ip addr add 192.168.4.1/25 dev enp0s8.2
sudo ip link set dev enp0s8 up
sudo ip link set dev enp0s9 up


#route table
sudo ip route add 192.168.2.0/23 via 10.0.0.2
