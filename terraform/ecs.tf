# ecs cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# ecs service 
resource "aws_ecs_service" "app-service" {
  name                          = "app-service"
  cluster                       = aws_ecs_cluster.ecs_cluster.id
  task_definition               = aws_ecs_task_definition.ecs_project.arn
  desired_count                 = 1
  platform_version              = "LATEST"
  launch_type                   = "FARGATE"
  scheduling_strategy           = "REPLICA"
  availability_zone_rebalancing = "ENABLED"

  deployment_circuit_breaker {
    enable   = "true"
    rollback = "true"
  }

  network_configuration {
    subnets          = [aws_subnet.public_subet_a.id, aws_subnet.public_subet_b.id]
    security_groups  = [aws_security_group.ecs-service-sg.id]
    assign_public_ip = "true"
  }

  depends_on = [aws_iam_role.ecsTaskExecutionRole,
  aws_ecs_task_definition.ecs_project, aws_ecs_cluster.ecs_cluster]

}

