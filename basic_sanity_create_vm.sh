#!/bin/env bash
set -xv

BASE_DIR=/home/root/

echo "Install pre-requistes packages"
yum install -y wget
sudo pip install virtualenv

mkdir -p $BASE_DIR/images
cd $BASE_DIR/images
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --disk-format qcow2 --container-format bare --public --file $BASE_DIR/images/cirros-0.4.0-x86_64-disk.img

echo "Install openstack pkgs"
virtualenv .op
source .op/bin/activate
yum install -y gcc python-devel
pip install python-openstackclient
pip install python-ironicclient
source /etc/kolla/kolla-toolbox/admin-openrc.sh

openstack image list
openstack flavor list
if [ "$1" == "dpdk" ]; then
    echo "creating dpdk required flavor type"
    openstack flavor create --ram 1024 --disk 20 --vcpus 1 --public small
    openstack flavor set small --property hw:mem_page_size=large
else
    echo "creating kernel required flavor type"
    openstack flavor create --ram 1024 --disk 20 --vcpus 1 --public small
fi
#create virtual-network
VN_NAME="vn1"
openstack network create $VN_NAME

#create subnet
SUBNET1="100.1.1.0/24"
openstack subnet create --subnet-range $SUBNET1 --network $VN_NAME SUBNET1

NET_ID=`openstack network list | grep ${VN_NAME} | awk -F '|' '{print $2}' | tr -d ' '`
echo $NET_ID

echo "Boot cirros VM"
nova boot --image cirros --flavor small --nic net-id=$NET_ID vm1
nova boot --image cirros --flavor small --nic net-id=$NET_ID vm2

sleep 10s

openstack server list
