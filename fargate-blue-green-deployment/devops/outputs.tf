# ----------------------------------------------------------------------------------------------
# CodeDeploy Application Name
# ----------------------------------------------------------------------------------------------
output "codedeploy_application" {
  value = aws_codedeploy_app.this.name
}

# ----------------------------------------------------------------------------------------------
# CodeDeploy Deployment Group Name
# ----------------------------------------------------------------------------------------------
output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.this.deployment_group_name
}