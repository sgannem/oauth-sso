## SPDX-FileCopyrightText: Copyright 2019 Amazon.com, Inc. or its affiliates
##
### SPDX-License-Identifier: MIT-0

##################################################
# AWS VPC Network - AWS VPC, IGW/NGW, EIP,
# Public/Private Subnets, Route Tables and Table Association
##################################################
resource "aws_vpc" "sso_auth_server_ecs_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.app_prefix-1}-VPC"
  }
}

resource "aws_subnet" "sso_auth_server_ecs_public_subnet1" {
  vpc_id     = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${var.app_prefix-1}-public-subnet1"
  }
}

resource "aws_subnet" "sso_auth_server_ecs_private_subnet1" {
  vpc_id     = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.app_prefix-1}-private-subnet1"
  }
}

resource "aws_internet_gateway" "sso_auth_server_ecs_igw" {
  vpc_id = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
}

resource "aws_route_table" "sso_auth_server_ecs_route_table" {
  vpc_id = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
}

resource aws_route "sso_auth_server_ecs_public_route" {
  route_table_id         = "${aws_route_table.sso_auth_server_ecs_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.sso_auth_server_ecs_igw.id}"
}

resource "aws_route_table_association" "sso_auth_server_ecs_route_table_association1" {
  subnet_id      = "${aws_subnet.sso_auth_server_ecs_public_subnet1.id}"
  route_table_id = "${aws_route_table.sso_auth_server_ecs_route_table.id}"
}

resource "aws_eip" "sso_auth_server_elastic_ip" {
  vpc = true

  tags = {
    Name = "${var.app_prefix-1}-elastic-ip"
  }
}

resource "aws_nat_gateway" "sso_auth_server_ecs_ngw" {
  allocation_id = "${aws_eip.sso_auth_server_elastic_ip.id}"
  subnet_id = "${aws_subnet.sso_auth_server_ecs_public_subnet1.id}"

  tags = {
    "Name" = "${var.app_prefix-1}-NATGateway"
  }
}

resource "aws_route_table" "sso_auth_server_ngw_route_table" {
  vpc_id = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
}

resource aws_route "sso_auth_server_ngw_route" {
  route_table_id         = "${aws_route_table.sso_auth_server_ngw_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.sso_auth_server_ecs_ngw.id}"
}

resource "aws_route_table_association" "sso_auth_server_ngw_route_table_association1" {
  subnet_id      = "${aws_subnet.sso_auth_server_ecs_private_subnet1.id}"
  route_table_id = "${aws_route_table.sso_auth_server_ngw_route_table.id}"
}

resource "aws_route_table" "sso_auth_server_vpce_route_table" {
  vpc_id = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
}

resource aws_route "sso_auth_server_vpce_route" {
  route_table_id         = "${aws_route_table.sso_auth_server_vpce_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_nat_gateway.sso_auth_server_ecs_ngw.id}"
}

#resource "aws_vpc_endpoint_route_table_association" "sso_auth_server_ngw_route_table_association2" {
#  route_table_id  = "${aws_route_table.sso_auth_server_vpce_route_table.id}"
#  vpc_endpoint_id = "${aws_vpc_endpoint.sso_auth_server_ecs_s3_vpc_endpoint.id}"
#}

resource "aws_security_group" "sso_auth_server_ecs_security_group" {
  name                   = "${var.app_prefix-1}-ECSSecurityGroup"
  description            = "ECS Allowed Ports"
  vpc_id                 = "${aws_vpc.sso_auth_server_ecs_vpc.id}"
}

resource "aws_security_group_rule" "sso_auth_server_ecs_security_group_rule" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sso_auth_server_ecs_security_group.id}"
}