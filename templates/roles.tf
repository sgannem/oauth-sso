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

resource "aws_iam_role_policy" "sso_auth_server_ecs_policy" {
  name = "${local.iam_policy_name}"
  role = "${aws_iam_role.stepfunction_ecs_role.id}"
  # Policy type: Inline policy
  # StepFunctionsGetEventsForECSTaskRule is AWS Managed Rule
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:GetLogEvents",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:PassRole"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowPushPull",
            "Resource": [
                "${aws_ecr_repository.sso-authorization-server.arn}"
            ],
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ]
        },
        {
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "${aws_sns_topic.sso_auth_server_ecs_sns.arn}"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "ecs:RunTask"
            ],
            "Resource": [
                "${aws_ecs_task_definition.sso_auth_server_ecs_task_definition.arn}"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "ecs:StopTask",
                "ecs:DescribeTasks"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "events:PutTargets",
                "events:PutRule",
                "events:DescribeRule"
            ],
            "Resource": [
                "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/StepFunctionsGetEventsForECSTaskRule"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
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