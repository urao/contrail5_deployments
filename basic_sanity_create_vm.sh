#!/bin/env bash
set -xv

BASE_DIR=/home/root/

echo "Install openstack pkgs"
yum install -y gcc python-devel
pip install python-openstackclient
pip install python-ironicclient

echo "Install wget packages"
yum install -y wget

mkdir -p $BASE_DIR/images
cd $BASE_DIR/images
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create "cirros" --disk-format qcow2 --container-format bare --public --file $BASE_DIR/images/cirros-0.4.0-x86_64-disk.img


source /etc/kolla/kolla-toolbox/admin-openrc.sh

openstack image list
openstack flavor list
openstack flavor create --ram 1024 --disk 20 --vcpus 1 --public small

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
