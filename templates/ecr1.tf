## SPDX-FileCopyrightText: Copyright 2019 Amazon.com, Inc. or its affiliates
##
### SPDX-License-Identifier: MIT-0

resource "aws_ecr_repository" "oauth_sso_ecs_ecr_repo" {
  name                 = "${var.sso-oauth}-repo"
  tags = {
    Name = "${var.sso-oauth}-ecr-repo"
  }
}

#resource "aws_ecr_repository" "oauth_sso_ecs_ecr_repo" {
#  name                 = "${var.app_prefix-1}-repo"
#  tags = {
#    Name = "${var.app_prefix-1}-ecr-repo"
#  }
#}