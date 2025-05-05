# security group for alb
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  vpc_id      = aws_vpc.dev_vpc.id
  description = "security group that allows http connection"

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb-sg-allow-http" {
  security_group_id = aws_security_group.alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb-sg-allow-egress" {
  security_group_id = aws_security_group.alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# security group for ecs service
resource "aws_security_group" "ecs-service-sg" {
  vpc_id      = aws_vpc.dev_vpc.id
  description = "security group that allows connection from alb"

  tags = {
    Name = "ecs-service-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs-service-sg-allow-alb" {
  security_group_id            = aws_security_group.ecs-service-sg.id
  referenced_security_group_id = aws_security_group.alb-sg.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs-service-sg-egress" {
  security_group_id = aws_security_group.ecs-service-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# security group for EFS
resource "aws_security_group" "efs-sg" {
  vpc_id      = aws_vpc.dev_vpc.id
  description = "security group for EFS"

  tags = {
    Name = "efs-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "efs-sg-allow-ecs" {
  security_group_id            = aws_security_group.efs-sg.id
  referenced_security_group_id = aws_security_group.ecs-service-sg.id
  from_port                    = 2049
  to_port                      = 2049
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "efs-sg-egress" {
  security_group_id = aws_security_group.efs-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
