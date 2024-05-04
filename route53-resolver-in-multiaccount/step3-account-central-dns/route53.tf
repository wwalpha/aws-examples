# # ----------------------------------------------------------------------------------------------
# # Route53 Record - Name Servers app1
# # ----------------------------------------------------------------------------------------------
# resource "aws_route53_record" "name_servers_app1" {
#   allow_overwrite = true
#   name            = "app1.${var.domain_name}"
#   ttl             = 172800
#   type            = "NS"
#   zone_id         = var.route53_hosted_zone_id

#   records = [
#     var.name_servers_app1[0],
#     var.name_servers_app1[1],
#     var.name_servers_app1[2],
#     var.name_servers_app1[3],
#   ]
# }

# # ----------------------------------------------------------------------------------------------
# # Route53 Record - Name Servers app2
# # ----------------------------------------------------------------------------------------------
# resource "aws_route53_record" "name_servers_app2" {
#   allow_overwrite = true
#   name            = "app2.${var.domain_name}"
#   ttl             = 172800
#   type            = "NS"
#   zone_id         = var.route53_hosted_zone_id

#   records = [
#     var.name_servers_app2[0],
#     var.name_servers_app2[1],
#     var.name_servers_app2[2],
#     var.name_servers_app2[3],
#   ]
# }


resource "aws_route53_zone_association" "app1" {
  vpc_id  = var.vpc_id_central_dns
  zone_id = var.hosted_zone_id_app1
}

resource "aws_route53_zone_association" "app2" {
  vpc_id  = var.vpc_id_central_dns
  zone_id = var.hosted_zone_id_app2
}
