
## Steps
- Create shared_service, workload_public, workload_private, onpremise vpc
- Create private hosted zone named master.local
- Create Route53 Resolver inbound and outbound endpoint with multi-az
- Create Onpremise DNS server and client
- Create public alb and ec2 in workload_public vpc
- Create private alb and ec2 in workload_private vpc
