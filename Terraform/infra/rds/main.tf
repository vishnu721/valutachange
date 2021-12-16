

data "terraform_remote_state" "vpc_info" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-remote-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_subnet" "db-subnet1" {
vpc_id = data.terraform_remote_state.vpc_info.outputs.id
cidr_block = "10.0.1.0/26"
availability_zone = "us-east-1a"
}

resource "aws_subnet" "db-subnet2" {
vpc_id = data.terraform_remote_state.vpc_info.outputs.id
cidr_block = "10.0.1.64/26"
availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "db-subnet-group" {
name = "db subnet group"
subnet_ids = ["${aws_subnet.db-subnet1.id}", "${aws_subnet.db-subnet2.id}"]
}

resource "aws_db_instance" "default" {
allocated_storage = 20
identifier = "sampleinstance"
storage_type = "gp2"
engine = "mysql"
engine_version = "5.7"
instance_class = "db.t2.micro"
name = "sample"
username = "dbadmin"
password = "DBAdmin123"
parameter_group_name = "default.mysql5.7"
multi_az = true
db_subnet_group_name = "${aws_db_subnet_group.db-subnet-group.name}"
vpc_security_group_ids = ["${aws_security_group.allow_db_access.id}"]
}

resource "aws_security_group" "allow_db_access" {
  name        = "eks-node-group-to-rds"
  description = "Allow DB inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc_info.outputs.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    #cidr_blocks      = ["${data.terraform_remote_state.vpc_info.outputs.eks-sg-id}"]
    security_groups  = ["${data.terraform_remote_state.vpc_info.outputs.eks-sg-id}"]
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
    Name = "eks-node-group-to-rds"
  }
}