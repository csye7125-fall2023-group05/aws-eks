output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets[*]
}

output "private_subnets" {
  value = aws_subnet.private_subnets[*]
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}

output "cluster_name" {
  value = local.cluster_name
}

output "region" {
  value = var.REGION
}
