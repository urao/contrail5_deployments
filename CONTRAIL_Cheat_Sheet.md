## Cheat sheet
#### Tested on CN 5.x

```
curl -X GET http://192.168.122.1:8787/v2/_catalog  [List of images]
curl -X GET http://192.168.122.1:8787/v2/contrail-node-init/tags/list [List all tags for an image]
curl -s https://<USER>:<PASWD>@hub.juniper.net/v2/contrail/contrail-vrouter-agent/tags/list | jq .name
curl -u <USER>:<PASWD> https://hub.juniper.net/v2/contrail/contrail-controller-config-dnsmasq/tags/list | jq .
curl -u <USER>:<PASWD> https://hub.juniper.net/v2/contrail/contrail-base/tags/list | jq . | grep 1912.L2
```

## Reference

[contrail](https://www.juniper.net/documentation/en_US/contrail5.1/topics/concept/install-contrail-ocata-kolla-50.html)
