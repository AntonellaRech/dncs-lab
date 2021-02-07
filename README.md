# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively {{ HostsASubnetRequiredAddresses }} and {{ HostsBSubnetRequiredAddresses }} usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to {{ HubSubnetRequiredAddresses }} usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

### Components
- HOST-A
- HOST-B
- HOST-C
- ROUTER-1
- ROUTER-2
- SWITCH

IMAGINE 

### Subnetting

There are 3 hosts for which one I have to create a network.
For the network of HOST-A, that I'm gonna call it "Subnet-A", there are 275 addresses so I shaped it with a private group of addresses 192.168.0.0 with prefix length of 23.    The prefix length it was choose by the following steps :
1. First 2^8= 256 are not enought because 275addresses>256 
2. So we need 9 bits, infact (2^9)-2 = 510>275addresses
3. 32bits - 9bits = 23bits available for the subnet.

The same procediment was done with the "Subnet-B" that has 89 addresses (prefix lenght 25) and "Subnet-C" with 330 addresses(prefix lenght 23).
For the routers i choose /30 as a length because there are only 2 router in the private subnet 10.0.0.0.

### Ports

Using one of the following command we can see which port for every component can be use

```
ip route show
ip link show
ip -s link
```

For example, the router-2: 

```
vagrant@router-2:~$ ip route show
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
```
enp0s3 is already busy

```
vagrant@router-2:~$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 02:57:50:35:f1:66 brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 08:00:27:d6:4e:91 brd ff:ff:ff:ff:ff:ff
4: enp0s9: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 08:00:27:24:00:ae brd ff:ff:ff:ff:ff:ff
```
So I'm gonna use enp0s8 and enp0s9 for router-2 (the same procediment was done with all the others component).

### My Network Design

|  HOST  | SUBNET ADDRESSES |  IP-CONFIG   | INTERFACE AVAILABLE|
| ------ | ---------------- | ------------ | ------------------ |
| HOST-A |  192.168.0.0/23  | 192.168.0.65 |       enp0s8       |
| HOST-B |  192.168.4.0/25  | 192.168.4.42 |       enp0s8       |
| HOST-C |  192.168.2.0/23  | 192.168.2.11 |       enp0s8       |

|  ROUTER  |      ADDRESSES     | SUBNET IP-CONFIG | INTERFACE AVAILABLE|
| -------- | -------------------| ---------------- | ------------------ |
| ROUTER-1 |    10.0.0.1/30     |    192.168.0.1   | enp0s8, enp0s9     |
| ROUTER-2 |    10.0.0.2/30     |    192.168.2.1   | enp0s8, enp0s9     |

(router-1 : 192.168.0.1 subnet-A, 192.168.4.1 subnet-B )

| SWITCH |  ASSIGNED INTERFACE  |    INTERFACE TAG     |
| ------ | -------------------- | -------------------- |
| HOST-A |      enp0s9          |     enp0s8.1         |
| HOST-B |      enp0s10         |     enp0s8.2         |

## VAGRANTFILE CONFIGURATION

In order to make everything works there is a line in the vagrantfile that i need to change:

``` ruby
 router1.vm.provision "shell", path: "router-1.sh"
```
In "path" i put the name of the file with the istructions to configure the component, so when vagrant runs it will gonna use these istructions to build the network proprely.
As we can see every component must have this kind of file, down here they are all implemented.

## DEVICES CONFIGURATION

### HOST-A
 In file "host-a.sh" i wrote the following commands.
 First I set a parameter in Kernel to specify what kind of protocol to use with this line
 ```sudo sysctl -w net.ipv4.ip_forward=1 ``` 
 that enable the ip forwarding with ip version 4 (or ipv4).
 Then I used ```sudo ip addr add 192.168.0.65/23 dev enp0s8 ``` to assign a group of IP addresses to an interface via the gateway address. In my case the "Subnet-A" to the interface enp0s8.
 This line ```sudo ip link set dev enp0s8 up``` help me to operate the network interface.
 Finally, this is the command to set static routes, which help packets directed to another network to be sent correctly to routers ```sudo ip route add [networkaddress\length] via [routeraddress]```
 
 ```export DEBIAN_FRONTEND=noninteractive
apt-get update
sudo sysctl -w net.ipv4.ip_forward=1

# Startup commands for host-a go here

sudo ip addr add 192.168.0.65/23 dev enp0s8
sudo ip link set dev enp0s8 up

#route table gateway

sudo ip route add 192.168.4.0/25 via 192.168.0.1
sudo ip route add 10.0.0.0/30 via 192.168.0.1
sudo ip route add 192.168.2.0/23 via 192.168.0.1 
```

### HOST-B
As in file "host-a.sh", the "host-b.sh" is pretty similar. Only the address added to interface enp0s8 and the static routes are different, 
as we can see this host is now accessible from router-1.
```
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
```

### SWITCH

In file "switch.sh" these lines allow to use the openvswitch command lines properly.
```
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
```
I configured the file with this line ```sudo ovs-vsctl add-br switch-1``` to create a bridge in the switch database then with this ```sudo ovs-vsctl add-port switch-1 enp0s8``` i binded an interface to a bridge and added a tag to convert ports into access port on specified VLAN.
For example in this one ```sudo ovs-vsctl add-port switch-1 enp0s9 tag="1"``` there is an access port connected to interface enp0s9 that is identified with tag 1.
In my case the interface enp0s9 is connected to the host-a while the interface enp0s10 is connected to the host-b and the interface enp0s8 is connected to router-1. The switch is now operating between the two host and the router-1. 

```
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
```

### ROUTER-1

In file "router-1.sh"  i added the addresses of router-1 and router-2 in the same interface (enp0s9) with the command ```sudo ip addr add 10.0.0.1/30 dev enp0s9``` so they can be connected. Also i need to manage the traffic of the switch came from the two different gateway addresses, respectively one of network of host-a and the other of the host-b. Here there are the lines to rename the interface connected to router-1 and switch and adding the identification tags to create the vlans that separate the traffic of host-a from host-b.
```
sudo ip link add link enp0s8 name enp0s8.1 type vlan id 1
sudo ip link add link enp0s8 name enp0s8.2 type vlan id 2
```
Now that we have the vlans we can associated a group of address for each vlan by adding the gateway ip of subnet-A and subnet-B.
```
sudo ip addr add 192.168.0.1/23 dev enp0s8.1
sudo ip addr add 192.168.4.1/25 dev enp0s8.2
```
These actions subdivide the subnet of router-1 in two more subnets managed by the switch.
The static route point the way to router-2.
```
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
```

### ROUTER-2

In file "router-2.sh" i added the address of router-2 to the interface enp0s9 where there is the other router connected, ```sudo ip addr add 10.0.0.2/30 dev enp0s9```.
Right below ```sudo ip addr add 192.168.2.1/23 dev enp0s8``` i connected the router-2 to the subnet-C by the gateway address just written.
Now in order to make accessible the host-c from host-a or host-b there are some static routes to implement that show the correct way to packets during the sending.

```
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
```

### HOST-C 

In file "host-c.sh" i added the ip address to the interface enp0s8 so it make easy to be reachable from router-2.
Differently from host-a and hot-b, this host has a docker image that has to be load so i need to install the most recent versione of docker ```sudo apt -y install docker.io``` and initialize the imagine by loading it ```sudo docker pull dustnic82/nginx-test``` and by running it ```sudo docker run --name nginx -p 80:80 -d dustnic82/nginx-test```.
It's important to tell the system to enable docker and runs it immediatly at startup with these lines 
```
sudo systemctl start docker
sudo systemctl enable docker
```
Finally the static routes are implemented for each network not directly connected to this host through router-2.

```
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
```

## CONCLUSION

### FINAL MOVES

Now that everything is done i'm gonna check if it works by using the command line ```ping [address]``` after logging into each device.
Whether it works the last thing to do is enter into host-a or host-b and make a request to host-c by using the command ```curl [address]``` (in my case 192.168.2.11) and receive an html file like this one:

```
<!DOCTYPE html>
<html>
<head>
<title>Hello World</title>
<link href="data:image/png;base64,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" rel="icon" type="image/png" />
<style>
body {
  margin: 0px;
  font: 20px 'RobotoRegular', Arial, sans-serif;
  font-weight: 100;
  height: 100%;
  color: #0f1419;
}
div.info {
  display: table;
  background: #e8eaec;
  padding: 20px 20px 20px 20px;
  border: 1px dashed black;
  border-radius: 10px;
  margin: 0px auto auto auto;
}
div.info p {
    display: table-row;
    margin: 5px auto auto auto;
}
div.info p span {
    display: table-cell;
    padding: 10px;
}
img {
    width: 176px;
    margin: 36px auto 36px auto;
    display:block;
}
div.smaller p span {
    color: #3D5266;
}
h1, h2 {
  font-weight: 100;
}
div.check {
    padding: 0px 0px 0px 0px;
    display: table;
    margin: 36px auto auto auto;
    font: 12px 'RobotoRegular', Arial, sans-serif;
}
#footer {
    position: fixed;
    bottom: 36px;
    width: 100%;
}
#center {
    width: 400px;
    margin: 0 auto;
    font: 12px Courier;
}

</style>
<script>
var ref;
function checkRefresh(){
    if (document.cookie == "refresh=1") {
        document.getElementById("check").checked = true;
        ref = setTimeout(function(){location.reload();}, 1000);
    } else {
    }
}
function changeCookie() {
    if (document.getElementById("check").checked) {
        document.cookie = "refresh=1";
        ref = setTimeout(function(){location.reload();}, 1000);
    } else {
        document.cookie = "refresh=0";
        clearTimeout(ref);
    }
}
</script>
</head>
<body onload="checkRefresh();">
<img alt="NGINX Logo" src="http://d37h62yn5lrxxl.cloudfront.net/assets/nginx.png"/>
<div class="info">
<p><span>Server&nbsp;address:</span> <span>172.17.0.2:80</span></p>
<p><span>Server&nbsp;name:</span> <span>61180820962f</span></p>
<p class="smaller"><span>Date:</span> <span>18/Jan/2021:21:32:04 +0000</span></p>
<p class="smaller"><span>URI:</span> <span>/</span></p>
</div>
<br>
<div class="info">
    <p class="smaller"><span>Host:</span> <span>192.168.2.11</span></p>
    <p class="smaller"><span>X-Forwarded-For:</span> <span></span></p>
</div>

<div class="check"><input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</div>
    <div id="footer">
        <div id="center" align="center">
            Request ID: 4a6db2df91ec4eede0e100baf2875171<br/>
            &copy; NGINX, Inc. 2018
        </div>
    </div>
</body>
</html>

```

### RESULT
Here the html page rendered.
https://github.com/AntonellaRech/dncs-lab/blob/master/RESULT.html

 http://htmlpreview.github.io/?https://github.com/AntonellaRech/dncs-lab/blob/master/RESULT.html
