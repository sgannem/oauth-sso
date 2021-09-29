locals {
  sso_auth_server_ecr_repo    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.app_prefix-1}-repo"
  sso_resource_server_ecr_repo    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.app_prefix-2}-repo"
  sso_client_app_1_ecr_repo    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.app_prefix-3}-repo"
  sso_client_app_2_ecr_repo    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.app_prefix-4}-repo"

  region      = "${data.aws_region.current.name}"
  sso_auth_server_log_group   = "${aws_cloudwatch_log_group.sso_authorization_server_ecs_container_cloudwatch_loggroup.name}"
  sso_resource_server_log_group   = "${aws_cloudwatch_log_group.sso_resource_server_ecs_container_cloudwatch_loggroup.name}"
  sso_client_app_1_log_group   = "${aws_cloudwatch_log_group.sso_client_app_1_ecs_container_cloudwatch_loggroup.name}"
  sso_client_app_2_log_group   = "${aws_cloudwatch_log_group.sso_client_app_2_ecs_container_cloudwatch_loggroup.name}"
}

##################################################
# AWS Fargate
##################################################
resource "aws_ecs_cluster" "sso_auth_server_ecs_cluster" {
  name = "${var.app_prefix-1}-ECSCluster"

  tags = {
    Name = "${var.app_prefix-1}-ecs-fargate-cluster"
  }
}

resource "aws_ecs_cluster" "sso_resource_server_ecs_cluster" {
  name = "${var.app_prefix-2}-ECSCluster"

  tags = {
    Name = "${var.app_prefix-2}-ecs-fargate-cluster"
  }
}

resource "aws_ecs_cluster" "sso_client_app_1_ecs_cluster" {
  name = "${var.app_prefix-3}-ECSCluster"

  tags = {
    Name = "${var.app_prefix-3}-ecs-fargate-cluster"
  }
}

resource "aws_ecs_cluster" "sso_client_app_2_ecs_cluster" {
  name = "${var.app_prefix-4}-ECSCluster"

  tags = {
    Name = "${var.app_prefix-4}-ecs-fargate-cluster"
  }
}

resource "aws_ecs_task_definition" "sso_auth_server_ecs_task_definition" {
  family                   = "${var.app_prefix-1}-ECSTaskDefinition"
  task_role_arn            = "${aws_iam_role.sso_auth_server_ecs_task_role.arn}"
  execution_role_arn       = "${aws_iam_role.sso_auth_server_ecs_task_execution_role.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${local.sso_auth_server_log_group}",
            "awslogs-region": "${local.region}",
            "awslogs-stream-prefix": "/aws/ecs"
          }
        },
    "cpu":0,
    "dnsSearchDomains":[],
    "dnsServers":[],
    "dockerLabels":{},
    "dockerSecurityOptions":[],
    "essential":true,
    "extraHosts":[],
    "image": "${local.sso_auth_server_ecr_repo}",
    "links":[],
    "mountPoints":[],
    "name": "fargate-app",
    "portMappings":[
      {
        "containerPort": 80,
        "hostPort":80,
        "protocol": "tcp"
      }
    ],
    "ulimits":[],
    "volumesFrom":[],
    "environment": [
        {"name": "REGION", "value": "${local.region}"}
    ]
  }
]
DEFINITION
}