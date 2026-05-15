# Key deployment outputs
output "alb_dns_name" {
  description = "DNS name of the public ALB."
  value       = aws_lb.nginx.dns_name
}

output "nginx_url" {
  description = "HTTP URL for the NGINX demo page."
  value       = "http://${aws_lb.nginx.dns_name}"
}

output "workload_vpc_id" {
  description = "ID of the workload VPC."
  value       = aws_vpc.workload.id
}

output "egress_vpc_id" {
  description = "ID of the egress VPC."
  value       = aws_vpc.egress.id
}

output "tgw_id" {
  description = "ID of the Transit Gateway."
  value       = aws_ec2_transit_gateway.demo.id
}

output "nginx_instance_id" {
  description = "Instance ID of the private NGINX EC2 instance."
  value       = aws_instance.nginx.id
}
