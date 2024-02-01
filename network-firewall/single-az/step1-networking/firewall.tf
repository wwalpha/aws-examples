resource "aws_networkfirewall_firewall_policy" "this" {
  name = "firewall-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:pass"]
  }
}

resource "aws_networkfirewall_firewall" "this" {
  name                              = "anfw"
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.this.arn
  vpc_id                            = aws_vpc.this.id
  delete_protection                 = false
  subnet_change_protection          = false
  firewall_policy_change_protection = false

  dynamic "subnet_mapping" {
    for_each = aws_subnet.firewall[*].id

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    "Name" = "firewall"
  }
}
