export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

# Startup commands for switch go here

sudo ovs-vsctl add-br switch-1
sudo ovs-vsctl add-port switch-1 enp0s8
sudo ovs-vsctl add-port switch-1 enp0s9 tag="1"
sudo ovs-vsctl add-port switch-1 enp0s10 tag="2"
sudo ip link set dev enp0s8 up
sudo ip link set dev enp0s9 up 
sudo ip link set dev enp0s10 up 


