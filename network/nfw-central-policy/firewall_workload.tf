# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Rule Group - Workload Allow
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "workload_allow" {
  capacity    = 100
  description = "Allow inbound HTTP traffic to the ALB subnets"
  name        = "${var.name_prefix}-workload-allow"
  type        = "STATEFUL"

  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }

    rules_source {
      stateful_rule {
        action = "PASS"

        header {
          destination      = local.workload_subnets["alb_public_a"].cidr
          destination_port = "80"
          direction        = "FORWARD"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["1001"]
        }
      }

      stateful_rule {
        action = "PASS"

        header {
          destination      = local.workload_subnets["alb_public_c"].cidr
          destination_port = "80"
          direction        = "FORWARD"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["1002"]
        }
      }
    }
  }

  tags = {
    Name = "${var.name_prefix}-workload-allow"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Firewall Policy - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "workload" {
  name = "${var.name_prefix}-workload-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_default_actions           = ["aws:drop_strict"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }

    stateful_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.workload_allow.arn
    }
  }

  tags = {
    Name = "${var.name_prefix}-workload-policy"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Firewall - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall" "workload" {
  name                = "${var.name_prefix}-workload-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.workload.arn
  vpc_id              = aws_vpc.workload.id

  subnet_mapping {
    subnet_id = aws_subnet.workload["nfw_endpoint_a"].id
  }

  subnet_mapping {
    subnet_id = aws_subnet.workload["nfw_endpoint_c"].id
  }

  tags = {
    Name = "${var.name_prefix}-workload-firewall"
  }
}
