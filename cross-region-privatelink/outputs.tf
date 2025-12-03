output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.test_server.id
}

output "hosted_zone_id" {
  description = "The ID of the private hosted zone"
  value       = aws_route53_zone.private.zone_id
}
