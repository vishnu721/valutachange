module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "myVPC"
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.0.0/26", "10.0.0.64/26"]
  private_subnets = ["10.0.0.128/26", "10.0.0.192/26"]
  enable_nat_gateway = false
  enable_vpn_gateway = false
  tags = {
      Env = "dev"
      Terraform = "true"
  }
}

resource "aws_security_group" "allow_eks_access" {
  name        = "alb-to-eks-access"
  description = "Allow eks nodes inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "eks-alb-to-node-group"
  }
}
