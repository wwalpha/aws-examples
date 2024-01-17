output "ws_endpoint" {
  value = "ws://${module.step5-app.alb_dns_name}"
}
