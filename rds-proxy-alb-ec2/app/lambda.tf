# ----------------------------------------------------------------------------------------------
# Lambda Function
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "app" {
  function_name     = "${var.prefix}-app"
  s3_bucket         = var.lambda_module_bucket_name
  s3_key            = var.lambda_module_bucket_key
  s3_object_version = var.lambda_module_version_id

  handler     = "index.handler"
  memory_size = 128
  role        = var.iam_role_arn_lambda_app
  runtime     = "nodejs14.x"
  timeout     = 10

  vpc_config {
    security_group_ids = [module.app_sg.security_group_id]
    subnet_ids         = var.private_subnets
  }

  environment {
    variables = {
      PGUSER     = var.database_username
      PGPASSWORD = var.database_password
      PGHOST     = var.database_proxy_endpoint
      PGDATABASE = "dvdrental"
      PGPORT     = "5432"
    }
  }
}

# ---------------------------------------------------------------------------------------------
# API Gateway Permission
# ---------------------------------------------------------------------------------------------
resource "aws_lambda_permission" "app" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*/"
}
