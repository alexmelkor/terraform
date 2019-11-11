resource "aws_lb" "gitlab" {
  name               = var.name
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = "GitLab"
  }
}

resource "aws_lb_target_group" "gitlab" {
  name        = "gitlab-lb-tg"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "gitlab_443" {
  target_group_arn = aws_lb_target_group.gitlab.arn
  target_id        = var.instance_id
  port             = 443
}

resource "aws_lb_target_group_attachment" "gitlab_80" {
  target_group_arn = aws_lb_target_group.gitlab.arn
  target_id        = var.instance_id
  port             = 80
}

resource "aws_lb_listener" "gitlab_443" {
  load_balancer_arn = aws_lb.gitlab.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab.arn
  }
}

resource "aws_lb_listener" "gitlab_80" {
  load_balancer_arn = aws_lb.gitlab.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab.arn
  }
}
