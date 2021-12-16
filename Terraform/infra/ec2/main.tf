data "terraform_remote_state" "vpc_info" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-remote-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

module "ec2-instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "2.12.0"
  name                   = "Demo-Instance2"
  instance_count         = 1
  ami                    = "ami-0f8f3e38c86610f2c"
  instance_type          = "t2.micro"
  key_name               = "LinuxServer"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc_info.outputs.default_security_group_id}", "${data.terraform_remote_state.vpc_info.outputs.eks-sg-id}"]
  subnet_id              = data.terraform_remote_state.vpc_info.outputs.public_subnet_ids[0]
  tags = {
    Terraform = "true"
    Env       = "dev"
    Name      = "Demo-Instance2"
  }
}






