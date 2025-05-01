
variable "AWS_REGION" {
  description = "AWS Region"
  type    = string
  # default = "us-east-1"
}

variable "AWS_ADMIN_USER_ARN" {
  description = "AWS IAM admin user arn"
  type    = string
  # default = "arn:aws:iam::861936062471:user/jay"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  # default = "dev-ecs"
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  # default = "dev_ecr_repo"
}

