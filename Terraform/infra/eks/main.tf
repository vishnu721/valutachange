locals {
  cluster_name = "my-eks-cluster"
}

data "terraform_remote_state" "vpc_info" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-remote-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"
  # insert the 7 required variables here
  cluster_name = local.cluster_name
  vpc_id       = data.terraform_remote_state.vpc_info.outputs.id
  subnets      = "${data.terraform_remote_state.vpc_info.outputs.private_subnet_ids}"

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capaicty     = 2

      instance_type = "t2.micro"
    }
  }

  manage_aws_auth = false
}
