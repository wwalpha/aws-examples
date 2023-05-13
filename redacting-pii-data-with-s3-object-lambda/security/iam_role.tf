# ----------------------------------------------------------------------------------------------
# IAM Role - Lambda
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "lambda" {
  name               = "${upper(var.prefix)}_LambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

# ----------------------------------------------------------------------------------------------
# IAM Role Policy Attachment - Lambda Basic
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_basic.arn
}
