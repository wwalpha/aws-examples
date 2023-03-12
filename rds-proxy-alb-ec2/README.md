# Application Load Balancer + EC2 + RDS Proxy + PostgreSQL

## What's the Keypoint

- Create custom instance using cloud-init
- Auto create database schema, tables and import datas
- Deploy Node.js Application for query database
- Using Secrets Manager for save database credentials
- Query via RDS Proxy Endpoint

## What's the Architecture

![image](./docs/ec2+proxy.png)

## How to do

```bash
$ terraform apply -auto-approve

db_endpoint = "rdsproxy-postgres.[c71cbtvdqkpj].ap-northeast-1.rds.amazonaws.com"
db_proxy_endpoint = "rdsproxy-progresql-proxy.proxy-[c71cbtvdqkpj].ap-northeast-1.rds.amazonaws.com"
ec2_instance_name = "rdsproxy-postgres"
load_balancer_dns_name = "rdsproxy-alb-[1009239331].ap-northeast-1.elb.amazonaws.com"

$ export ALB_DNS_NAME=$(terraform output -raw load_balancer_dns_name)
$ curl "http://$ALB_DNS_NAME/v1/query"

{"film_id":1,"title":"Academy Dinosaur","description":"A Epic Drama of a Feminist And a Mad Scientist who must Battle a Teacher in The Canadian Rockies","release_year":2006,"language_id":1,"rental_duration":6,"rental_rate":"0.99","length":86,"replacement_cost":"20.99","rating":"PG","last_update":"2013-05-26T14:50:58.951Z","special_features":["Deleted Scenes","Behind the Scenes"],"fulltext":"'academi':1 'battl':15 'canadian':20 'dinosaur':2 'drama':5 'epic':4 'feminist':8 'mad':11 'must':14 'rocki':21 'scientist':12 'teacher':17"}
```
