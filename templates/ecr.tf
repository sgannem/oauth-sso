## SPDX-FileCopyrightText: Copyright 2019 Amazon.com, Inc. or its affiliates
##
### SPDX-License-Identifier: MIT-0

resource "aws_ecr_repository" {
  name                 = "${var.app_prefix}-repo"
  tags = {
    Name = "${var.app_prefix}-ecr-repo"
  }
}