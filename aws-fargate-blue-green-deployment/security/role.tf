# ----------------------------------------------------------------------------------------------
# AWS ECS Task Execution Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_exec" {
  name               = "${var.prefix}_ECSTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json

  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Task Execution Policy - ECS Task Execution Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecs_task_exec" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Task Execution Policy - ECS Task Execution Policy
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecs_task_exec_cloudwatch" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Task Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task" {
  name               = "${var.prefix}_ECSTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json

  lifecycle {
    create_before_destroy = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS CodeDeploy Role
# ----------------------------------------------------------------------------------------------
resource "aws_iam_role" "code_deploy" {
  name               = "${var.prefix}_CodeDeployRole"
  assume_role_policy = data.aws_iam_policy_document.code_deploy.json

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy_attachment" "code_deploy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.code_deploy.name
}
