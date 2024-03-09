# ----------------------------------------------------------------------------------------------
# AWS Load Balancer DNS Name - Nginx
# ----------------------------------------------------------------------------------------------
output "lb_dns_name_nginx" {
  value = "http://${module.app.lb_dns_name_nginx}"
}

# ----------------------------------------------------------------------------------------------
# AWS Load Balancer DNS Name - Apache
# ----------------------------------------------------------------------------------------------
output "lb_dns_name_apache" {
  value = "http://${module.app.lb_dns_name_apache}"
}
