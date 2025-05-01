// outputs.tf
output "infrastructure_output" {
  value = {
    aws_account_id  = data.aws_caller_identity.current.account_id
    ecs_repo_name = aws_ecr_repository.dev_ecr_repo.name
    vpc_id = aws_vpc.dev_vpc.id
  }
}