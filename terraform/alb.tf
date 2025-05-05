# ALB 
resource "aws_lb" "ecs-alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public_subet_a.id, aws_subnet.public_subet_b.id]

  tags = {
    Name = "ecs-alb"
  }
}

# ALB listener 
resource "aws_lb_listener" "ecs-alb-listener" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg.arn
  }
}

# target group 
resource "aws_lb_target_group" "ecs-tg" {
  name        = "ecs-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.dev_vpc.id

  health_check {
    path                = "/notes"
    port                = 3000
    protocol            = "HTTP"
    interval            = 30
    timeout             = 15
    healthy_threshold   = 3
    unhealthy_threshold = 10
  }
}
