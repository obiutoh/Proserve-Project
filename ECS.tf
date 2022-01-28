resource "aws_ecs_cluster" "web-cluster" {
  name               = "web-cluster"
  capacity_providers = [aws_ecs_capacity_provider.test-run.name]
  tags = {
    "env"       = "dev"
    "createdBy" = "obi"
  }
}
resource "aws_ecs_capacity_provider" "test-run" {
  name = "test-run"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.scalling_ecs_asg.arn
    managed_termination_protection = "ENABLED"
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}
# The update file container-def, so it's pulling image from ecr
resource "aws_ecs_task_definition" "task-definition-testing" {
  family                = "web-family"
  container_definitions = file("contaner-def.json")
  network_mode = "bridge"
   
  tags = {
    "env"       = "dev"
    "createdBy" = "obi"

  }
}

resource "aws_ecs_service" "services" {
  name            = "services"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-testing.arn
  desired_count   = 5
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.balancer-target.arn
    container_name   = "prince-slon"
    container_port   = 80
  }
  # The Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.web-listeners]
}
resource "aws_cloudwatch_log_group" "log_groups" {
  name = "/ecs/frontends-container"
  tags = {
    
    "env"       = "dev"
    "createdBy" = "obi"
  }
} 