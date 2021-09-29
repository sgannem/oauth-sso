## SPDX-FileCopyrightText: Copyright 2019 Amazon.com, Inc. or its affiliates
##
### SPDX-License-Identifier: MIT-0


resource "aws_ecr_repository" "sso-authorization-server" {
  name                 = "${var.app_prefix-1}-repo"
  tags = {
    Name = "${var.app_prefix-1}-ecr-repo"
  }
}

resource "aws_ecr_repository" "sso-resource-server" {
  name                 = "${var.app_prefix-2}-repo"
  tags = {
    Name = "${var.app_prefix-2}-ecr-repo"
  }
}

resource "aws_ecr_repository" "sso-client-app-1" {
  name                 = "${var.app_prefix-3}-repo"
  tags = {
    Name = "${var.app_prefix-3}-ecr-repo"
  }
}

resource "aws_ecr_repository" "sso-client-app-2" {
  name                 = "${var.app_prefix-4}-repo"
  tags = {
    Name = "${var.app_prefix-4}-ecr-repo"
  }
}