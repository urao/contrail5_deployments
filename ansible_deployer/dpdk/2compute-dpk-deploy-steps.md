
## Steps to deploy Contrail + 2 DPDK computes 

1. Bring up 3 Centos 7.4 Servers with recommended specifications for Contrail deployments
2. Install required packages
```
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.4.2.0
```
3. Download  [Contrail 5.0 GA code](https://www.juniper.net/support/downloads/?p=contrail#sw),
```
tar -zxvf contrail-ansible-deployer-5.0.0-0.40.tgz
cd contrail-ansible-deployer
```
4. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/ansible_deployer/working-instance-files/instance_contrail_k8s.yaml)
5. Install Contrail with 2 DPDK computes
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ playbooks/configure_instances.yml 
```
6. Deploy Contrail 
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=openstack playbooks/install_contrail.yml
```
