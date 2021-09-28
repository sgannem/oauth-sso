## SPDX-FileCopyrightText: Copyright 2019 Amazon.com, Inc. or its affiliates
 ##
 ### SPDX-License-Identifier: MIT-0


variable "app_prefix-1" {
  description = "Application prefix for the AWS services that are built"
  default = "sso-authorization-server"
}
variable "app_prefix-2" {
  description = "Application prefix for the AWS services that are built"
  default = "sso-resource-server"
}
variable "app_prefix-3" {
  description = "Application prefix for the AWS services that are built"
  default = "sso-client-app-1"
}
variable "app_prefix-4" {
  description = "Application prefix for the AWS services that are built"
  default = "sso-client-app-2"
}


variable "stage_name" {
  default = "dev"
  type    = string
}