
## Steps
- Create shared_service, workload_public, workload_private, onpremise vpc
- Create private hosted zone named master.aws
- Create Route53 Resolver inbound and outbound endpoint with multi-az
- Create Route53 Resolver Rule
- Share Route53 Resolver rules to membar accounts
- Create Onpremise DNS server and client
- Create DNS zone named master.local
- Create public alb and ec2 in workload_public vpc
- Create private alb and ec2 in workload_private vpc
- Create ssm endpoints in workload_public, workload_private vpc

## Use Cases
- Onpremise vpc to workload private vpc
- Workload private vpc to onpremise client
- Workload public vpc to workload private
