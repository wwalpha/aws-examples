# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Log Group - Workload NFW
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "workload_nfw" {
  name              = "/aws/network-firewall/${var.name_prefix}-workload"
  retention_in_days = var.log_retention_days
}

# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Log Group - Egress NFW
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "egress_nfw" {
  name              = "/aws/network-firewall/${var.name_prefix}-egress"
  retention_in_days = var.log_retention_days
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Logging Configuration - Workload
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_logging_configuration" "workload" {
  firewall_arn = aws_networkfirewall_firewall.workload.arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.workload_nfw.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }

    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.workload_nfw.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Network Firewall Logging Configuration - Egress
# ----------------------------------------------------------------------------------------------
resource "aws_networkfirewall_logging_configuration" "egress" {
  firewall_arn = aws_networkfirewall_firewall.egress.arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.egress_nfw.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }

    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.egress_nfw.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}
