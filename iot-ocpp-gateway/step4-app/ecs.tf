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
resource "aws_ecs_task_definition" "example" {
  container_definitions    = "[{\"command\":[],\"cpu\":0,\"dnsSearchDomains\":[],\"dnsServers\":[],\"dockerLabels\":{},\"dockerSecurityOptions\":[],\"entryPoint\":[],\"environment\":[{\"name\":\"AWS_REGION\",\"value\":\"ap-northeast-1\"},{\"name\":\"DYNAMODB_CHARGE_POINT_TABLE\",\"value\":\"AwsOcppGatewayStack-ChargePointTable0F8300CB-1XCIDGMIAHS16\"},{\"name\":\"IOT_ENDPOINT\",\"value\":\"a13869jpvvkeq-ats.iot.ap-northeast-1.amazonaws.com\"},{\"name\":\"IOT_PORT\",\"value\":\"8883\"},{\"name\":\"OCPP_GATEWAY_PORT\",\"value\":\"80\"},{\"name\":\"OCPP_PROTOCOLS\",\"value\":\"ocpp1.6,ocpp2.0,ocpp2.0.1\"}],\"environmentFiles\":[],\"essential\":true,\"extraHosts\":[],\"image\":\"334678299258.dkr.ecr.ap-northeast-1.amazonaws.com/cdk-hnb659fds-container-assets-334678299258-ap-northeast-1:54bb477662008be37c1b2a4c3944d11a0801c00cee45255db5c0347539857764\",\"links\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"AwsOcppGatewayStack-LogGroupF5B46931-prkaDaQrM9Js\",\"awslogs-region\":\"ap-northeast-1\",\"awslogs-stream-prefix\":\"Gateway\"},\"secretOptions\":[]},\"mountPoints\":[{\"containerPath\":\"/etc/iot-certificates/\",\"readOnly\":false,\"sourceVolume\":\"iot-certificate-volume\"}],\"name\":\"Container\",\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\"}],\"secrets\":[{\"name\":\"IOT_AMAZON_ROOT_CA\",\"valueFrom\":\"arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTAmazonRootCAStorage2C3D4-hqP9jEMX0CTV-jfDYdb\"},{\"name\":\"IOT_GATEWAY_CERTIFICATE\",\"valueFrom\":\"arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTPemCertificate43539AB1-ukXv1Sxd8Gby-1gg0u0\"},{\"name\":\"IOT_GATEWAY_PUBLIC_KEY\",\"valueFrom\":\"arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTPublicCertificate41596AD-AaaBXTRnkjj9-7UchKQ\"},{\"name\":\"IOT_GATEWAY_PRIVATE_KEY\",\"valueFrom\":\"arn:aws:secretsmanager:ap-northeast-1:334678299258:secret:IOTPrivateCertificateCD8C5E-dC1LKHE8JOnE-TN5ayM\"}],\"systemControls\":[],\"ulimits\":[{\"hardLimit\":65536,\"name\":\"nofile\",\"softLimit\":65536}],\"volumesFrom\":[]}]"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.ecs_execution_role_arn
  family                   = "AwsOcppGatewayStackTaskC4A181FA"
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
  task_definition                    = "AwsOcppGatewayStackTaskC4A181FA:1"

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
    target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:334678299258:targetgroup/AwsOcp-LoadB-1PTLILT2BIW6/b0bdf6de5fac67f2"
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = ["sg-0f5b2486df3932a13"]
    subnets          = ["subnet-0aee12b6dd175d25a", "subnet-0b180c56fe4e4b482", "subnet-0db9b426831166979"]
  }
}
