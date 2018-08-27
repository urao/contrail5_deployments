### Steps to delete compute node from maria db
1. Get the container id of the mariadb
```
container_id = docker ps -aqf "name=mariadb"
```
2. Get a bash shell in the container
```
docker exec -it <container_id> bash
```
3. Connect to mysql db and delete the compute_node with Id
```
mysql --user=<user_name> --password=<password>
use nova;
SELECT id, created_at, updated_at, hypervisor_hostname FROM compute_nodes;
DELETE FROM compute_nodes WHERE id="14";
SELECT id, created_at, updated_at, hypervisor_hostname FROM compute_nodes;
SELECT id, created_at, updated_at, host FROM services;
DELETE FROM services WHERE id="101";
```
4. Check compute nodes
```
openstack hypervisor list
```
