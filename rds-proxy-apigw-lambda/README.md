# Application Load Balancer + EC2 + RDS Proxy + PostgreSQL

## Architecture

![image](../docs/ec2-proxy.png)

## Prerequisite

- Terraform

## Demonstrate

```bash
$ terraform apply -auto-approve

$ export ALB_DNS_NAME=$(terraform output alb_dns_name)
$ curl "$ALB_DNS_NAME/v1/query"
```
