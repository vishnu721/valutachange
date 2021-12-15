terraform {
  backend "s3" {
    bucket = "s3-bucket-remote-state"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}