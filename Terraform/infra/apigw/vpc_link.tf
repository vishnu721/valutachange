data "terraform_remote_state" "vpc_info" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-remote-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_apigatewayv2_vpc_link" "example" {
  name               = "example"
  security_group_ids = [data.aws_security_group.vpc_link_sg.id]
  subnet_ids         = "${data.terraform_remote_state.vpc_info.outputs.private_subnet_ids}"

}

resource "aws_security_group" "vpc_link_sg" {
  name        = "vpc_link_sg"
  description = "VPC Link SG"
  vpc_id      = data.terraform_remote_state.vpc_info.outputs.id

  ingress {
    description      = "VPC Link SG"
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
    Name = "vpc-link-sg"
  }
}

