#!/bin/bash

echo "Install packages"
sudo pip install virtualenv
virtualenv .op
source .op/bin/activate
sudo pip install python-openstackclient 
sudo pip install python-heatclient


echo "source openrc.sh file"
source /etc/kolla/kolla-toolbox/admin-openrc.sh

openstack token issue
curl -X GET -H "X-Auth-Token:$(openstack token issue | awk '/ id / {print $4}')" \
      http://<Controller_IP>:8081/analytics/uves/vrouters | python -mjson.tool
curl -X GET -H "X-Auth-Token:$(openstack token issue | awk '/ id / {print $4}')" \
      http://localhost:8081/analytics/alarms | python -mjson.tool
