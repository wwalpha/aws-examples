# output "route_table_association_ids" {
#   value = module.networking.route_table_association_ids
# }

# output "route_table_ids" {
#   value = module.networking.route_table_ids
# }

# data "aws_route_table" "selected" {
#   subnet_id = module.networking.public_subnets[0]
# }

# output "route_table" {
#   value = data.aws_route_table.selected
# }
# output "firewall" {
#   value = module.networking.firewall
# }

# output "private_subnets_cidr_block" {
#   value = module.networking.private_subnets[*].cidr_block
# }
