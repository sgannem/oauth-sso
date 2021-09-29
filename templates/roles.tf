locals {
  iam_role_name       = "${var.app_prefix-1}-ECSRunTaskSyncExecutionRole"
  iam_policy_name     = "FargateTaskNotificationAccessPolicy"
  iam_task_role_policy_name = "${var.app_prefix-1}-ECS-Task-Role-Policy"
}


resource "aws_iam_role" "stepfunction_ecs_role" {
  name               = "${local.iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.sso_auth_server_ecs_policy_document.json}"
}

data "aws_iam_policy_document" "sso_auth_server_ecs_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

###
# ECS Tasks - role and executution roles
###

resource "aws_iam_role" "sso_auth_server_ecs_task_execution_role" {
  name = "${var.app_prefix-1}-ECS-TaskExecution-Role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_role" "sso_auth_server_ecs_task_role" {
  name = "${var.app_prefix-1}-ECS-Task-Role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = "${aws_iam_role.sso_auth_server_ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Grant task role for the actions to be performed
resource "aws_iam_role_policy_attachment" "ecs_task_role_s3_attachment" {
  role       = "${aws_iam_role.sso_auth_server_ecs_task_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}