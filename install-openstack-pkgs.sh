#!/bin/bash

echo "Install packages"
sudo yum install -y gcc python-devel
sudo pip install python-openstackclient
sudo yum install openstack-utils
 
echo "source openrc.sh file"
source /etc/kolla/kolla-toolbox/admin-openrc.sh

openstack-status
