#########################################
# CLOUDWATCH LOG GROUP
#########################################

resource "aws_cloudwatch_log_group" "airflow" {

  name = "/ecs/${var.app_name}-airflow-${var.env}"

  retention_in_days = 7
}

#########################################
# ALB TARGET GROUP
#########################################

resource "aws_lb_target_group" "airflow" {

  name = "${var.app_name}-airflow-tg"

  port = 8080

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/health"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 3
  }
}

#########################################
# ECS TASK DEFINITION
#########################################

resource "aws_ecs_task_definition" "airflow" {

  family = "${var.app_name}-airflow-${var.env}"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = 512

  memory = 1024

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([

    {

      name = "${var.app_name}-airflow"

      image = "${var.ecr_repository_url}:s2pb-app-airflow-${var.env}"

      essential = true

      portMappings = [

        {

          containerPort = 8080

          hostPort = 8080

          protocol = "tcp"
        }
      ]

      environment = [

        {
          name = "AIRFLOW__CORE__EXECUTOR"

          value = "SequentialExecutor"
        },

        {
          name = "AIRFLOW__CORE__LOAD_EXAMPLES"

          value = "False"
        },

        {
          name = "_AIRFLOW_WWW_USER_USERNAME"

          value = "admin"
        },

        {
          name = "_AIRFLOW_WWW_USER_PASSWORD"

          value = "admin"
        }
      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.airflow.name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

#########################################
# ECS SERVICE
#########################################

resource "aws_ecs_service" "airflow" {

  name = "${var.app_name}-airflow-service-${var.env}"

  cluster = var.ecs_cluster_id

  task_definition = aws_ecs_task_definition.airflow.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.public_subnets

    security_groups = [
      aws_security_group.airflow_sg.id
    ]

    assign_public_ip = true
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.airflow.arn

    container_name = "${var.app_name}-airflow"

    container_port = 8080
  }

  depends_on = [
    aws_lb_target_group.airflow
  ]
}


resource "aws_lb_listener_rule" "airflow" {

  listener_arn = var.alb_listener_arn

  priority = 200

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.airflow.arn
  }

  condition {

    path_pattern {

      values = ["/airflow*"]
    }
  }
}