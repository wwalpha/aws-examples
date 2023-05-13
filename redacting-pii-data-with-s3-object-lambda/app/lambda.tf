# ----------------------------------------------------------------------------------------------
# Lambda Function
# ----------------------------------------------------------------------------------------------
resource "aws_lambda_function" "this" {
  function_name    = "${var.prefix}-redacting-pii"
  filename         = data.archive_file.lambda_default.output_path
  source_code_hash = data.archive_file.lambda_default.output_base64sha256
  handler          = "index.handler"
  memory_size      = 128
  role             = var.iam_role_arn_lambda
  runtime          = "nodejs18.x"
  timeout          = 10
}

# ----------------------------------------------------------------------------------------------
# Archive file - Lambda default module
# ----------------------------------------------------------------------------------------------
data "archive_file" "lambda_default" {
  type        = "zip"
  output_path = "${path.module}/dist/default.zip"

  source {
    content  = <<EOT
export const handler = async(event) => {
    console.log(event);
    // TODO implement
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};
EOT
    filename = "index.mjs"
  }
}

# ---------------------------------------------------------------------------------------------
# API Gateway Permission
# ---------------------------------------------------------------------------------------------
# resource "aws_lambda_permission" "this" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.app.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*/"
# }
