# ----------------------------------------------------------------------------------------------
# AWS ECS Cluster
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "this" {
  name = "${var.prefix}-Cluster"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Task Definition
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "this" {
  family = "${var.prefix}-Gateway"
  container_definitions = jsonencode([
    {
      command               = [],
      cpu                   = 0,
      dnsSearchDomains      = [],
      dnsServers            = [],
      dockerLabels          = {},
      dockerSecurityOptions = [],
      entryPoint            = [],
      environment = [
        {
          name  = "AWS_REGION",
          value = "${local.region}"
        },
        {
          name  = "DYNAMODB_CHARGE_POINT_TABLE",
          value = "${var.dynamodb_table_charge_point}"
        },
        {
          name  = "IOT_ENDPOINT",
          value = "${local.iot_endpoint}"
        },
        {
          name  = "IOT_PORT",
          value = "8883"
        },
        {
          name  = "OCPP_GATEWAY_PORT",
          value = "80"
        },
        {
          name  = "OCPP_PROTOCOLS",
          value = "ocpp1.6,ocpp2.0,ocpp2.0.1"
        }
      ],
      environmentFiles = [],
      essential        = true,
      image            = "${aws_ecr_repository.this.repository_url}:latest",
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "${var.prefix}-Gateway",
          awslogs-region        = "${local.region}",
          awslogs-stream-prefix = "Gateway"
        },
        secretOptions = []
      },
      mountPoints = [
        {
          containerPath = "/etc/iot-certificates/",
          readOnly      = false,
          sourceVolume  = "iot-certificate-volume"
        }
      ],
      name = "Container",
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ],
      secrets = [
        {
          name      = "IOT_AMAZON_ROOT_CA",
          valueFrom = var.iot_amazon_root_ca_arn
          # valueFrom = "arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTAmazonRootCAStorage2C3D4-hqP9jEMX0CTV-jfDYdb"
        },
        {
          name      = "IOT_GATEWAY_CERTIFICATE",
          valueFrom = var.iot_pem_certificate_arn
          # valueFrom = "arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTPemCertificate43539AB1-ukXv1Sxd8Gby-1gg0u0"
        },
        {
          name      = "IOT_GATEWAY_PUBLIC_KEY",
          valueFrom = var.iot_public_key_arn
          # valueFrom = "arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTPublicCertificate41596AD-AaaBXTRnkjj9-7UchKQ"
        },
        {
          name      = "IOT_GATEWAY_PRIVATE_KEY",
          valueFrom = var.iot_private_key_arn
          # valueFrom = "arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTPrivateCertificateCD8C5E-dC1LKHE8JOnE-TN5ayM"
        }
      ]
    }
  ])
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.ecs_task_role_arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  volume {
    host_path = null
    name      = "iot-certificate-volume"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS ECS Service - Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ecs_service" "gateway" {
  cluster                            = aws_ecs_cluster.this.id
  name                               = "${var.prefix}-Gateway"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  enable_ecs_managed_tags            = false
  enable_execute_command             = false
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  propagate_tags                     = "NONE"
  scheduling_strategy                = "REPLICA"
  task_definition                    = data.aws_ecs_task_definition.latest.arn

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "Container"
    container_port   = 80
    elb_name         = null
    target_group_arn = aws_lb_target_group.this.arn
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.ocpp_gw_sg.security_group_id]
    subnets          = var.vpc_private_subnet_ids
  }
}

data "aws_ecs_task_definition" "latest" {
  task_definition = aws_ecs_task_definition.this.family
}
