# # ----------------------------------------------------------------------------------------------
# # Lambda Function - Cognito
# # ----------------------------------------------------------------------------------------------
# resource "aws_lambda_function" "this" {
#   filename         = "${path.module}/dist/default.zip"
#   function_name    = "${local.prefix}-s3event"
#   handler          = local.lambda_handler
#   memory_size      = 128
#   role             = aws_iam_role.lambda.arn
#   runtime          = local.lambda_runtime
#   timeout          = 10
#   source_code_hash = data.archive_file.lambda.output_base64sha256
# }

# # ----------------------------------------------------------------------------------------------
# # Archive File - Lambda Source
# # ----------------------------------------------------------------------------------------------
# data "archive_file" "lambda" {
#   type        = "zip"
#   output_path = "${path.module}/dist/default.zip"

#   source {
#     content  = <<EOT
# exports.handler = async (event) => {
#   const response = {
#     statusCode: 200,
#     body: JSON.stringify('Hello from Lambda!'),
#   };
#   return response;
# };
# EOT
#     filename = "index.js"
#   }
# }
