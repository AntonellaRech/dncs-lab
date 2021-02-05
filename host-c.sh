export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo sysctl -w net.ipv4.ip_forward=1
# Startup commands for host-c go here

sudo ip addr add 192.168.2.11/23 dev enp0s8

sudo apt -y install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull dustnic82/nginx-test
sudo docker run --name nginx -p 80:80 -d dustnic82/nginx-test

sudo ip link set dev enp0s8 up

#route table
sudo ip route add 192.168.0.0/23 via 192.168.2.1
sudo ip route add 192.168.4.0/25 via 192.168.2.1
sudo ip route add 10.0.0.0/30 via 192.168.2.1
