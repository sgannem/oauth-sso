

resource "aws_sns_topic" "sso_auth_server_ecs_sns" {
  name = "${var.app_prefix-1}-SNSTopic"
}