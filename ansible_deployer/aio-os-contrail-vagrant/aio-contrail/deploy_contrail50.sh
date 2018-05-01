#!/bin/bash

echo "Deploy contrail..."

echo "Step 1: Configure instances..."

cd contrail-ansible-deployer
ansible-playbook -i inventory/ playbooks/configure_instances.yml

echo "Step 1: Done..."

echo "Step 2: Install contrail..."
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=openstack playbooks/install_contrail.yml

echo "Step 2: Done..."
echo "Contrail Deployment is done !!!"

echo "Step 3: Reboot.."
sudo reboot
echo "Step 3: Done.."
