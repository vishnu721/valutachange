output "id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnets
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnets
  description = "List of public subnet IDs"
}

output "default_security_group_id" {
    value = module.vpc.default_security_group_id
}

output "eks-sg-id" {
  value       = aws_security_group.allow_eks_access.id
  description = "SG ID"
}