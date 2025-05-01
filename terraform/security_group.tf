# security group for alb
resource "aws_security_group" "alb_sg" {
  vpc_id      = aws_vpc.dev_vpc.id 
  description = "security group that allows http connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "alb_sg"
  }
}

# security group for ecs service
resource "aws_security_group" "ecs_service_sg" {
  vpc_id      = aws_vpc.dev_vpc.id 
  description = "security group that allows connection from alb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "alb_sg"
  }
}

