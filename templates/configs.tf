## SPDX-FileCopyrightText: Copyright 2019 Amazon.com, Inc. or its affiliates
 ##
 ### SPDX-License-Identifier: MIT-0
 
variable "app_prefix" {
  description = "Application prefix for the AWS services that are built"
  default = "my-oauth-sso-app"
}

variable "stage_name" {
  default = "dev"
  type    = string
}