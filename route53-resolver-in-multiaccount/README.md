
## Steps
- Create shared_service, workload_app1, workload_app2, onpremise vpc
- Create private hosted zone named master.aws
- Create Route53 Resolver inbound and outbound endpoint with multi-az
- Create Route53 Resolver Rule
- Share Route53 Resolver rules to membar accounts
- Create Onpremise DNS server and client
- Create DNS zone named master.local
- Create public alb and ec2 in workload_app1 vpc
- Create private alb and ec2 in workload_app2 vpc
- Create ssm endpoints in workload_app1, workload_app2 vpc

## Use Cases
- Onpremise vpc to workload private vpc
- Workload private vpc to onpremise client
- Workload public vpc to workload private
