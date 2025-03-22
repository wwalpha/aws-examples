# ----------------------------------------------------------------------------------------------
# Lambda Function - Check Auth
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "check_auth" {
  function_name     = "${local.prefix}-CheckAuth"
  handler           = "bundle.handler"
  memory_size       = 128
  role              = aws_iam_role.lambda.arn
  runtime           = "nodejs20.x"
  publish           = true
  s3_bucket         = aws_s3_object.lambda_default.bucket
  s3_key            = aws_s3_object.lambda_default.key
  s3_object_version = aws_s3_object.lambda_default.version_id
  timeout           = 5
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - Refresh Auth
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "refresh_auth" {
  function_name     = "${local.prefix}-RefreshAuth"
  handler           = "bundle.handler"
  memory_size       = 128
  role              = aws_iam_role.lambda.arn
  runtime           = "nodejs20.x"
  publish           = true
  s3_bucket         = aws_s3_object.lambda_default.bucket
  s3_key            = aws_s3_object.lambda_default.key
  s3_object_version = aws_s3_object.lambda_default.version_id
  timeout           = 5
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - Sign Out
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "sign_out" {
  function_name     = "${local.prefix}-SignOut"
  handler           = "bundle.handler"
  memory_size       = 128
  role              = aws_iam_role.lambda.arn
  runtime           = "nodejs20.x"
  publish           = true
  s3_bucket         = aws_s3_object.lambda_default.bucket
  s3_key            = aws_s3_object.lambda_default.key
  s3_object_version = aws_s3_object.lambda_default.version_id
  timeout           = 5
}

# ----------------------------------------------------------------------------------------------
# Lambda Function -  Http Headers
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "http_headers" {
  function_name     = "${local.prefix}-HttpHeaders"
  handler           = "bundle.handler"
  memory_size       = 128
  role              = aws_iam_role.lambda.arn
  runtime           = "nodejs20.x"
  publish           = true
  s3_bucket         = aws_s3_object.lambda_default.bucket
  s3_key            = aws_s3_object.lambda_default.key
  s3_object_version = aws_s3_object.lambda_default.version_id
  timeout           = 5
}

# ----------------------------------------------------------------------------------------------
# Lambda Function - Parse Auth
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "parse_auth" {
  function_name     = "${local.prefix}-ParseAuth"
  s3_bucket         = aws_s3_object.lambda_default.bucket
  s3_key            = aws_s3_object.lambda_default.key
  s3_object_version = aws_s3_object.lambda_default.version_id
  handler           = "bundle.handler"
  runtime           = "nodejs20.x"
  memory_size       = 128
  role              = aws_iam_role.lambda.arn
  publish           = true
  timeout           = 5
}
