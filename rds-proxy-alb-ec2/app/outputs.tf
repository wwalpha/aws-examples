output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "ec2_instance_id" {
  value = module.ec2_instance.id
}
