[
  {
    "name": "${container_name}",
    "image": "${container_image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "/ecs/${container_name}",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
