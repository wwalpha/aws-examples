# ----------------------------------------------------------------------------------------------
# IAM Role - Lambda
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "lambda_bucket_event" {
  name               = "${var.prefix}_BucketEventRole"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
  ]
}
