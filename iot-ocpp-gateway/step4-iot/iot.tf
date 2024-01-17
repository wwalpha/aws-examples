# ----------------------------------------------------------------------------------------------
# AWS IoT Certificate
# ----------------------------------------------------------------------------------------------
resource "aws_iot_certificate" "this" {
  ca_pem = file("${path.module}/AmazonRootCA.pem")
  active = true
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Policy Document
# ----------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = ["iot:*"]
    resources = ["*"]
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iot_policy" "this" {
  name   = "${var.prefix}_Policy"
  policy = data.aws_iam_policy_document.this.json
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Policy Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_iot_policy_attachment" "this" {
  policy = aws_iot_policy.this.name
  target = aws_iot_certificate.this.arn
}
