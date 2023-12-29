# Site to Site VPN with OnPremise IP Overlapping

## Prerequisite
- Terraform
- Yarn

## Provision
```
$ yarn start

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

customer_gateway_address_eu = "52.192.171.75"
customer_gateway_address_jp = "13.115.34.216"
customer_gateway_address_us = "52.196.5.141"
relay_nlb_private_ip_eu = "10.0.0.10"
relay_nlb_private_ip_jp = "10.2.0.10"
relay_nlb_private_ip_us = "10.1.0.10"
server_address_eu = "52.69.227.79"
server_address_jp = "43.206.234.244"
server_address_us = "54.249.153.201"
tunnel_address_eu = "54.199.181.57"
tunnel_address_jp = "52.199.0.141"
tunnel_address_us = "13.115.237.39"
Done in 91.56s.

# Testing in Server EU
$ curl http://10.0.0.10
Application host on AWS
```

## Destroy
```
$ yarn destroy
```

![img](./docs/site-to-site-vpn.png)