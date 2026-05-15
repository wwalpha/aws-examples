# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Rule Group - Egress Allow
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "egress_allow" {
  capacity    = 100
  description = "Allow outbound HTTP and HTTPS traffic from the workload VPC"
  name        = "${var.name_prefix}-egress-allow"
  type        = "STATEFUL"

  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }

    rules_source {
      stateful_rule {
        action = "PASS"

        header {
          destination      = "ANY"
          destination_port = "80"
          direction        = "FORWARD"
          protocol         = "TCP"
          source           = local.workload_vpc_cidr
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["2001"]
        }
      }

      stateful_rule {
        action = "PASS"

        header {
          destination      = "ANY"
          destination_port = "443"
          direction        = "FORWARD"
          protocol         = "TCP"
          source           = local.workload_vpc_cidr
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["2002"]
        }
      }
    }
  }

  tags = {
    Name = "${var.name_prefix}-egress-allow"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Firewall Policy - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "egress" {
  name = "${var.name_prefix}-egress-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_default_actions           = ["aws:drop_strict"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }

    stateful_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.egress_allow.arn
    }
  }

  tags = {
    Name = "${var.name_prefix}-egress-policy"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Firewall - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_firewall" "egress" {
  name                = "${var.name_prefix}-egress-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.egress.arn
  vpc_id              = aws_vpc.egress.id

  subnet_mapping {
    subnet_id = aws_subnet.egress["nfw_endpoint_a"].id
  }

  tags = {
    Name = "${var.name_prefix}-egress-firewall"
  }
}
