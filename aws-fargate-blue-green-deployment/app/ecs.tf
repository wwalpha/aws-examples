# ----------------------------------------------------------------------------------------------
# ECS Cluster
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "this" {
  name = "${var.prefix}-cluster"
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Service - Task Definition
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "this" {
  depends_on         = [null_resource.docker_image]
  family             = "${var.prefix}-task"
  task_role_arn      = var.ecs_task_role_arn
  execution_role_arn = var.ecs_task_exec_role_arn
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  skip_destroy       = true

  requires_compatibilities = [
    "FARGATE"
  ]

  container_definitions = templatefile(
    "${path.module}/taskdefs/definition.tpl",
    {
      container_name  = var.prefix
      container_image = "${aws_ecr_repository.this.repository_url}:${var.environment}"
      container_port  = 8080
    }
  )
}

# ----------------------------------------------------------------------------------------------
# ECS Service 
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_service" "this" {
  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this,
    aws_lb.this
  ]

  name                               = "${var.prefix}-service"
  cluster                            = aws_ecs_cluster.this.id
  launch_type                        = "FARGATE"
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 0
  wait_for_steady_state              = false
  scheduling_strategy                = "REPLICA"
  enable_ecs_managed_tags            = true

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = var.prefix
    container_port   = 8080
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    assign_public_ip = true
    subnets          = var.public_subnet_ids
    security_groups = [
      module.alb_sg.security_group_id
    ]
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}
