# ----------------------------------------------------------------------------------------------
# Amazon S3 Object Lambda Access Point
# ----------------------------------------------------------------------------------------------
resource "aws_s3control_object_lambda_access_point" "this" {
  name = "${var.prefix}-object-lambda-ap"

  configuration {
    supporting_access_point = var.s3_access_point_arn

    transformation_configuration {
      actions = ["GetObject"]

      content_transformation {
        aws_lambda {
          function_arn = aws_lambda_function.this.arn
        }
      }
    }
  }
}
