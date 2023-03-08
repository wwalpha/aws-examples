output "iam_role_arn_ecs_task" {
  value = aws_iam_role.ecs_task.arn
}

output "iam_role_arn_ecs_task_exec" {
  value = aws_iam_role.ecs_task_exec.arn
}

output "iam_role_arn_code_deploy" {
  value = aws_iam_role.code_deploy.arn
}
