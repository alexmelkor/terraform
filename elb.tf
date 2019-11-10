
resource "aws_lb" "gitlab" {
  name               = "gitlab-gavno"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public.id] // TODO: Clarify what the difference in public.*.id and public.id

  enable_deletion_protection = false

  tags = {
    Environment = "GitLab"
  }
}

// TODO: Investigate how to use modules to reduce code duplication
resource "aws_lb_target_group" "gitlab" {
  name        = "gitlab-lb-tg"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.gitlab.id

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "gitlab_443" {
  target_group_arn = aws_lb_target_group.gitlab.arn
//  target_id        = aws_instance.gitlab.id
  target_id        = module.gitlab_instance.id
  port             = 443
}

resource "aws_lb_target_group_attachment" "gitlab_80" {
  target_group_arn = aws_lb_target_group.gitlab.arn
//  target_id        = aws_instance.gitlab.id
  target_id        = module.gitlab_instance.id
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
