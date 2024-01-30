resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "${var.ENV}-eks-${random_string.suffix.result}"
}

data "aws_availability_zones" "azs" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR_BLOCK
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "${local.cluster_name}-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.cluster_name}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${local.cluster_name}-public-route-table"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.PUBLIC_SUBNETS)
  cidr_block              = var.PUBLIC_SUBNETS[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  map_public_ip_on_launch = true

  tags = {
    "Name"                                        = "${local.cluster_name}-public-subnet-${count.index}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }
}

resource "aws_route_table_association" "public_subnets_rta" {
  count          = length(var.PUBLIC_SUBNETS)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.PRIVATE_SUBNETS)
  cidr_block              = var.PRIVATE_SUBNETS[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  map_public_ip_on_launch = false

  tags = {
    "Name"                                        = "${local.cluster_name}-private-subnet-${count.index}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}
