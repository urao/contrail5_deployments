#!/bin/bash

HOSTNAME=$1

echo "Setting hostname to $HOSTNAME"
hostname $hostname
cat <<EOF > /etc/hostname
$HOSTNAME
EOF

cat <<EOF >> /etc/hosts
$IPADDR           $HOSTNAME
EOF
hostname $HOSTNAME

echo "Base pkgs......"
yum update -y
yum install -y epel-release
yum install -y git ansible net-tools
echo "Done!!!"

echo "Enabling/Disabling services"
systemctl disable firewalld
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
echo "Done!!!!"

echo "Clone contrail-ansible-deployer"
git clone http://github.com/Juniper/contrail-ansible-deployer
sudo chown -R vagrant:vagrant /home/vagrant/contrail-ansible-deployer
echo "Done!!!!"
