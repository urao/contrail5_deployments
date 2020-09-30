
## Steps to deploy Contrail 5.0.2 + Openshift 3.9 + 1 compute

1. Bring up 3 RHEL 7.5 Servers or Virtual Machines with recommended specifications for Contrail deployments
2. One Master node, One Contrail node, One Compute node
3. Install required packages and do subscription on all nodes by the script, [install_pkgs.sh](https://github.com/urao/contrail5_deployments/blob/master/5_0_2_deployments/openshift_3.9/files/install-pkgs.sh)
4. Download  [Contrail + Openshift 3.9 5.0.2 GA code](https://www.juniper.net/support/downloads/?p=contrail#sw), on Master node
```
tar -zxvf contrail-openshift-deployer-5.0.2-0.360.tgz
cd openshift-ansible/
```
4. Copy [ose-install-non-ha](https://github.com/urao/contrail5_deployments/blob/master/5_0_2_deployments/openshift_3.9/files/ose-install-non-ha) 
   into $HOME/contrail-ansible-deployer/inventory/ folder as ose-install
5. Add docker registry credentials and make IP address changes as per your topology
6. Execute the below commands from Master node.
```
ansible-playbook -i inventory/ose-install playbooks/prerequisites.yml
ansible-playbook -i inventory/ose-install playbooks/deploy_cluster.yml
```
7. Access Contrail UI
```
https://<IP_Address_masteroc_node>:8143
```
8. To set password for the Openshift Console, run below commands on Master node
```
htpasswd /etc/origin/master/htpasswd admin
oc adm policy add-cluster-role-to-user cluster-admin admin 
```
9. Access Openshift UI
```
https://<FQDN_masteroc_node>:8443/console
```
10. Run sample pod, [pod1.yaml](https://github.com/urao/contrail5_deployments/blob/master/5_0_2_deployments/openshift_3.9/examples/pod1.yaml) on Master node
```
oc create -f pod1.yaml
```
11. Check the pod is created and assigned IP address
```
# oc get pods -o wide
NAME                       READY     STATUS    RESTARTS   AGE       IP               NODE
docker-registry-1-g77bt    1/1       Running   0          20h       10.47.255.250    infraoc
myapp-pod                  1/1       Running   4          4h        10.47.255.249    computeoc
registry-console-1-nbrw2   1/1       Running   0          20h       10.47.255.251    computeoc
router-1-slgqv             1/1       Running   0          20h       192.168.122.62   infraoc
```
## **Reference**
* [Contrail Wiki Link](https://github.com/Juniper/contrail-kubernetes-docs/tree/master/install/openshift)
* [Openshift Command Cheat Sheet](http://design.jboss.org/redhatdeveloper/marketing/openshift_cheatsheet/cheatsheet/images/openshift_cheat_sheet_r3v1.pdf)
