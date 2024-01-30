locals {
  cluster_name    = var.cluster_name
  PUBLIC_SUBNETS  = var.PUBLIC_SUBNETS
  PRIVATE_SUBNETS = var.PRIVATE_SUBNETS
  vpc_id          = var.vpc_id
}

resource "aws_eip" "elastic_ip" {
  count  = length(local.PUBLIC_SUBNETS)
  domain = "vpc"

  tags = {
    "Name" = "${local.cluster_name}-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(local.PUBLIC_SUBNETS)
  allocation_id = aws_eip.elastic_ip[count.index].id
  subnet_id     = local.PUBLIC_SUBNETS[count.index].id

  tags = {
    "Name" = "${local.cluster_name}-nat-gw-${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.internet_gateway]
}

# Private route table
resource "aws_route_table" "private_route_table" {
  count  = length(local.PRIVATE_SUBNETS)
  vpc_id = local.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "${local.cluster_name}-private-route-table-${count.index}"
  }
}

resource "aws_route_table_association" "private_subnets_rta" {
  count          = length(var.PRIVATE_SUBNETS)
  subnet_id      = local.PRIVATE_SUBNETS[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
