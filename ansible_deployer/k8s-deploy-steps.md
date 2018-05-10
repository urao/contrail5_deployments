
## Steps to deploy 2 node Contrail + k8s 

1. Bring up 2 Centos 7.4 VMs with 4 vCPU, 32 GB of RAM and 100 GB of disk
2. Install required packages
```
yum install -y epel-release
yum install -y git python-pip net-tools sshpass
pip install ansible==2.4.2.0
```
3. Clone/Download  contrail-ansible-deployer
```
cd
git clone http://github.com/Juniper/contrail-ansible-deployer
cd contrail-ansible-deployer
```
4. Copy [instances.yaml](https://github.com/urao/contrail5_deployments/blob/master/ansible_deployer/working-instance-files/instance_contrail_k8s.yaml)
5. Install Contrail and K8s requirements
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ playbooks/configure_instances.yml 
```
6. Deploy Contrail and k8s containers
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=kubernetes playbooks/install_contrail.yml
```
