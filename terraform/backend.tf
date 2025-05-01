terraform {
  backend "s3" {
    bucket = "jayambar-terraform-backend"
    key = "ecs-devops/state.tfstate"
    region = "us-east-1"
    profile = "default"
  }
}