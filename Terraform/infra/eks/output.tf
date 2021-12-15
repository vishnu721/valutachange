output "eks-sg-id" {
  value       = aws_security_group.allow_eks_access.eks.vpc_id
  description = "SG ID"
}