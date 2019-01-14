
## Steps to deploy Contrail 5.0.2 + 1 Kernel computes + 1 CSN

1. Bring up 4 Centos 7.5 (1804) Servers or Virtual Machines with recommended specifications for Contrail deployments, 
   one deployer VM, 1 contrail Controller+OpenStack VM, 1 Compute and 1 CSN
2. Install required packages on deployer VM
```
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.4.2.0
```
3. Download  [Contrail 5.0.2 GA code](https://www.juniper.net/support/downloads/?p=contrail#sw),
```
tar -zxvf contrail-ansible-deployer-5.0.2-0.360.tgz
cd contrail-ansible-deployer
```
4. Copy [instances_csn.yaml](https://github.com/urao/contrail5_deployments/blob/master/5_0_2_deployments/instances.yaml) 
   into $HOME/contrail-ansible-deployer/config/ folder
5. Rename instances_csn.yaml to instances.yaml
5. Add docker registry credentials and make IP address changes as per your topology
6. Execute the below commands from deployer VM.
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=openstack playbooks/configure_instances.yml
```
7. Deploy Openstack 
```
ansible-playbook -i inventory/ playbooks/install_openstack.yml
```
8. Deploy Contrail 
```
ansible-playbook -i inventory/ -e orchestrator=openstack playbooks/install_contrail.yml
```
