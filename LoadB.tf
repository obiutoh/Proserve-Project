resource "aws_lb" "test-lb1" {
  name               = "test-lb1"
  load_balancer_type = "application"
  internal           = false
  subnet_mapping {
      subnet_id = aws_subnet.Public1_Subnet.id
  }

  subnet_mapping {
      subnet_id = aws_subnet.Public2_Subnet.id
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "obi"
  }
  security_groups = [aws_security_group.lb-security.id]
}

resource "aws_security_group" "lb-security" {
  name   = "allow-all-lb"
  vpc_id = aws_vpc.Project_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "obi"
  }
}

resource "aws_lb_target_group" "balancer-target" {
  name        = "balancer-target"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Project_vpc.id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "web-listeners" {
  load_balancer_arn = aws_lb.test-lb1.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.balancer-target.arn
  }
}