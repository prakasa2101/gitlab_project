################################################################################
# VPC
################################################################################

output "vpc-id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc-arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

################################################################################
# Subnets
################################################################################

output "public-subnet1-id" {
  description = "ID of the public subnet1"
  value       = aws_subnet.subnet1.id
}

output "public-subnet2-id" {
  description = "ID of the public subnet2"
  value       = aws_subnet.subnet2.id
}

output "private-subnet1-id" {
  description = "ID of the public subnet3"
  value       = aws_subnet.subnet3.id
}

output "private-subnet2-id" {
  description = "ID of the public subnet4"
  value       = aws_subnet.subnet4.id
}

output "public-subnet1-arn" {
  description = "ARN of the public subnet1"
  value       = aws_subnet.subnet1.id
}

output "public-subnet2-arn" {
  description = "ARN of the public subnet2"
  value       = aws_subnet.subnet2.id
}

output "private-subnet1-arn" {
  description = "ARN of the public subnet3"
  value       = aws_subnet.subnet3.id
}

output "private-subnet2-arn" {
  description = "ARN of the public subnet4"
  value       = aws_subnet.subnet4.id
}

################################################################################
# Subnets
################################################################################

output "internet-gateway-id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat-gateway-id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.ngw.id
}

output "public-rt-table-id" {
  description = "ID of the NAT Gateway"
  value       = aws_route_table.public-rt-table.id
}


output "private-rt-table-id" {
  description = "ID of the NAT Gateway"
  value       = aws_route_table.private-rt-table.id
}
