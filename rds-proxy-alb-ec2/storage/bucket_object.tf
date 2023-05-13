
# ----------------------------------------------------------------------------------------------
# Archive file - Lambda default module
# ----------------------------------------------------------------------------------------------
data "archive_file" "lambda_default" {
  depends_on  = [null_resource.app]
  type        = "zip"
  output_path = "${path.module}/dist/default.zip"
  source_dir  = "${path.module}/module"
}

# ----------------------------------------------------------------------------------------------
# Null Resource
# ----------------------------------------------------------------------------------------------
resource "null_resource" "app" {
  triggers = {
    file_content_md5 = md5(file("./storage/module/index.ts"))
  }

  provisioner "local-exec" {
    command = "cd storage/module && yarn install"
  }
}

# ----------------------------------------------------------------------------------------------
# S3 Object - Lambda module
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "lambda_module" {
  bucket = aws_s3_bucket.archive.bucket
  key    = "lambda.zip"
  source = data.archive_file.lambda_default.output_path
  etag   = data.archive_file.lambda_default.output_md5
}
