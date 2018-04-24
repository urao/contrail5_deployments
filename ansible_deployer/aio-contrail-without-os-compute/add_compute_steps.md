
## Steps to add compute to all-in-one Contrail without Kolla Ocata OpenStack

1. Bring up a Centos 7.4 VM with 4 vCPU, 32 GB of RAM and 100 GB of disk with default partition
2. VM will have 1 NIC, eth0 configured with static IP/DHCP.
3. Make sure internet is accessible via interface eth0
4. Copy [instances_addcompute.yaml](https://github.com/urao/contrail5_deployments/blob/master/ansible_deployer/aio-contrail-without-os-compute/instances.yaml) into config/ folder
5. Rename the above yaml file to instances.yaml
6. Make sure ansible version 2.4.2.0 is running, by default 2.5.x is installed
```
pip uninstall ansible
pip install ansible=2.4.2.0
```
7. Install Contrail requirements
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ playbooks/configure_instances.yml 
```
8. Verify if the requirements  was successful.
```
**********************************************************************************
192.168.122.207            : ok=52   changed=34   unreachable=0    failed=0
192.168.122.84             : ok=44   changed=11   unreachable=0    failed=0
localhost                  : ok=4    changed=2    unreachable=0    failed=0
```
9. Deploy Contrail containers
```
cd contrail-ansible-deployer
ansible-playbook -i inventory/ -e orchestrator=none playbooks/install_contrail.yml
```
10. Verify if the deployment  was successful.
```

PLAY RECAP ***********************************************************************************************************************************
192.168.122.207            : ok=50   changed=13   unreachable=0    failed=0
192.168.122.84             : ok=91   changed=27   unreachable=0    failed=0
localhost                  : ok=2    changed=1    unreachable=0    failed=0
```
11. Verify if 56 containers are UP and running
```
#contrail-status
Pod      Service  Original Name           State    Status
vrouter  agent    contrail-vrouter-agent  running  Up 36 minutes
vrouter  nodemgr  contrail-nodemgr        running  Up 36 minutes

vrouter kernel module is PRESENT
== Contrail vrouter ==
nodemgr: active
agent: active

# lsmod | grep vr
vrouter               464339  2
```
## Access to Contrail UI console

1. Browse to the IP http://<VM_IP_ADDRESS>:8143 and login with the user "admin" and the password "contrail123"

## Reference
[Contrail Wiki Link](https://github.com/Juniper/contrail-ansible-deployer/wiki/Contrail-with-Kolla-Ocata)
[Contrail FAQ Link](https://github.com/Juniper/contrail-ansible-deployer/wiki/Provisioning-F.A.Q)

