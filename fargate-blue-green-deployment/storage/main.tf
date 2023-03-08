# ----------------------------------------------------------------------------------------------
# Amazon S3 Bucket - Configs
# ----------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "configs" {
  bucket = "${var.prefix}-configs"
}

# ----------------------------------------------------------------------------------------------
# Amazon S3 Bucket Object - AppSpec
# ----------------------------------------------------------------------------------------------
resource "aws_s3_object" "appspec" {
  bucket  = aws_s3_bucket.configs.bucket
  key     = "appspec.yaml"
  content = <<EOT
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "${var.ecs_task_definition_arn}"
        LoadBalancerInfo:
          ContainerName: "bluegreen"
          ContainerPort: 8080
        PlatformVersion: "LATEST"
EOT
}
