#!/usr/bin/env bash
# Tested on centos 7.4

set -e

if [[ $(id -u) -ne 0 ]]; then
   echo "Please run this script as root user"
   exit 1
fi
   
function install_vagrant_on_ubuntu () {
   echo "Coming soon!!!"
}

function install_vagrant_on_centos () {

   echo "Install required packages for Vagrant to be installed on Centos"
   yum update
   yum -y install gcc dkms make qt libgomp patch
   yum -y install kernel-headers kernel-devel binutils glibc-headers glibc-devel font-forge yum-utils
   yum-config-manager --add-repo http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
   yum install -y VirtualBox-5.2
   yum groupinstall "Development tools" -y
   yum install dkms kernel-devel -y
   /sbin/rcvboxdrv setup

   if [[ -z $(vagrant up) ]]; then
      echo "Vagrant is already installed, Hence exiting!!!"
      exit 0
   else
      echo "Vagrant is not installed, Hence installing....."
      yum -y install https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.rpm
      vagrant plugin install vagrant-vbguest
      exit 0
   fi
}

if [ -f /etc/lsb-release ]; then
   install_vagrant_on_ubuntu
elif [ -f /etc/redhat-release ]; then
   install_vagrant_on_centos 
else
   echo "Unsupported OS for now !!!"
   exit 1
fi

