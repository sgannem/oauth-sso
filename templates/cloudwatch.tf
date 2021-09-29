resource "aws_cloudwatch_log_group" "sso_authorization_server_ecs_container_cloudwatch_loggroup" {
  name = "${var.app_prefix-1}-cloudwatch-log-group"

  tags = {
    Name        = "${var.app_prefix-1}-cloudwatch-log-group"
    Environment = "${var.stage_name}"
  }
}

resource "aws_cloudwatch_log_group" "sso_resource_server_ecs_container_cloudwatch_loggroup" {
  name = "${var.app_prefix-2}-cloudwatch-log-group"

  tags = {
    Name        = "${var.app_prefix-2}-cloudwatch-log-group"
    Environment = "${var.stage_name}"
  }
}

resource "aws_cloudwatch_log_group" "sso_client_app_1_ecs_container_cloudwatch_loggroup" {
  name = "${var.app_prefix-3}-cloudwatch-log-group"

  tags = {
    Name        = "${var.app_prefix-3}-cloudwatch-log-group"
    Environment = "${var.stage_name}"
  }
}

resource "aws_cloudwatch_log_group" "sso_client_app_2_ecs_container_cloudwatch_loggroup" {
  name = "${var.app_prefix-4}-cloudwatch-log-group"

  tags = {
    Name        = "${var.app_prefix-4}-cloudwatch-log-group"
    Environment = "${var.stage_name}"
  }
}

resource "aws_cloudwatch_log_stream" "sso_authorization_server_ecs_container_cloudwatch_logstream" {
  name = "${var.app_prefix-1}-cloudwatch-log-group"
  log_group_name =  "${aws_cloudwatch_log_group.sso_authorization_server_ecs_container_cloudwatch_loggroup.name}"
}

resource "aws_cloudwatch_log_stream" "sso_resource_server_ecs_container_cloudwatch_logstream" {
  name = "${var.app_prefix-2}-cloudwatch-log-group"
  log_group_name =  "${aws_cloudwatch_log_group.sso_resource_server_ecs_container_cloudwatch_loggroup.name}"
}

resource "aws_cloudwatch_log_stream" "sso_client_app_1_ecs_container_cloudwatch_logstream" {
  name = "${var.app_prefix-3}-cloudwatch-log-stream"
  log_group_name =  "${aws_cloudwatch_log_group.sso_client_app_1_ecs_container_cloudwatch_loggroup.name}"
}

resource "aws_cloudwatch_log_stream" "sso_client_app_2_ecs_container_cloudwatch_logstream" {
  name = "${var.app_prefix-4}-cloudwatch-log-stream"
  log_group_name =  "${aws_cloudwatch_log_group.sso_client_app_2_ecs_container_cloudwatch_loggroup.name}"
}