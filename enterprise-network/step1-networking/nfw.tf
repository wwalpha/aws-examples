# ----------------------------------------------------------------------------------------------
# AWS Network Firewall - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall" "egress" {
  name                              = "${var.prefix}-egress"
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.egress.arn
  vpc_id                            = aws_vpc.egress.id
  delete_protection                 = false
  subnet_change_protection          = false
  firewall_policy_change_protection = false

  dynamic "subnet_mapping" {
    for_each = aws_subnet.egress_firewall[*].id

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    "Name" = "${var.prefix}-egress"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Policy - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "egress" {
  name = "${var.prefix}-egress-policy"

  firewall_policy {
    # stateful_default_actions           = ["aws:alert_strict", "aws:drop_established"]
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:pass"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }
  }
}


# ----------------------------------------------------------------------------------------------
# AWS Network Firewall - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall" "inspection" {
  name                              = "${var.prefix}-inspection"
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.inspection.arn
  vpc_id                            = aws_vpc.inspection.id
  delete_protection                 = false
  subnet_change_protection          = false
  firewall_policy_change_protection = false

  dynamic "subnet_mapping" {
    for_each = aws_subnet.inspection_firewall[*].id

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    "Name" = "${var.prefix}-inspection"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Policy - Inspection
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "inspection" {
  name = "${var.prefix}-FirewallPolicy"

  firewall_policy {
    # stateful_default_actions           = ["aws:alert_strict", "aws:drop_established"]
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:pass"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }
  }
}

# resource "aws_networkfirewall_firewall_policy" "inspection" {
#   name = "${var.prefix}-FirewallPolicy"

#   firewall_policy {
#     stateless_default_actions          = ["aws:forward_to_sfe"]
#     stateless_fragment_default_actions = ["aws:forward_to_sfe"]

#     stateful_rule_group_reference {
#       resource_arn = aws_networkfirewall_rule_group.allow_domain.arn
#     }

#     stateless_rule_group_reference {
#       priority     = 1
#       resource_arn = aws_networkfirewall_rule_group.stateless.arn
#     }
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # # # ----------------------------------------------------------------------------------------------
# # # # AWS Network Firewall Logging Configuration 
# # # # ----------------------------------------------------------------------------------------------
# # # resource "aws_cloudwatch_log_group" "firewall" {
# # #   name = "/aws/firewall/${var.suffix}"

# # #   retention_in_days = 1
# # # }

# # # # ----------------------------------------------------------------------------------------------
# # # # AWS Network Firewall Logging Configuration - FLOW/ALERT
# # # # ----------------------------------------------------------------------------------------------
# # # resource "aws_networkfirewall_logging_configuration" "flow_log" {
# # #   firewall_arn = aws_networkfirewall_firewall.this.arn

# # #   logging_configuration {
# # #     log_destination_config {
# # #       log_destination = {
# # #         logGroup = aws_cloudwatch_log_group.firewall.name
# # #       }
# # #       log_destination_type = "CloudWatchLogs"
# # #       log_type             = "FLOW"
# # #     }
# # #     log_destination_config {
# # #       log_destination = {
# # #         logGroup = aws_cloudwatch_log_group.firewall.name
# # #       }
# # #       log_destination_type = "CloudWatchLogs"
# # #       log_type             = "ALERT"
# # #     }
# # #   }
# # # }
