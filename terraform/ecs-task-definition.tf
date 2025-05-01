resource "aws_ecs_task_definition" "ecs_project" {
  family                   = "ecs_project"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "mongodb"
      image     = "mongo"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        { "name" : "MONGO_INITDB_ROOT_USERNAME", "value" : "mongoadmin" },
        { "name" : "MONGO_INITDB_ROOT_PASSWORD", "value" : "secret" },
      ]
    },
    {
      name      = "myapp"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.AWS_REGION}.amazonaws.com/${aws_ecr_repository.dev_ecr_repo.name}:myapp"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 27017
          hostPort      = 27017
        }
      ]
      environment = [
        { "name" : "MONGO_USER", "value" : "mongoadmin" },
        { "name" : "MONGO_PASSWORD", "value" : "secret" },
        { "name" : "MONGO_IP", "value" : "mongodb" },
        { "name" : "MONGO_PORT", "value" : "27017" },
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  volume {
    name = "efs-mongo-storage"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.mongodb-efs.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = aws_efs_access_point.mongodb-efs-access-point.id
        iam             = "ENABLED"
      }
    }
  }

  depends_on = [aws_ecr_repository.dev_ecr_repo, aws_iam_role.ecsTaskExecutionRole]
}
