provider "aws" {
  region = "us-east-1"
  profile = "default"
}

resource "aws_s3_bucket" "s3-bucket-remote-state" {
  bucket = "s3-bucket-remote-state"
  versioning {
      enabled = true
    }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    "Name" = "s3-bucket-remote-state"
    "Description" = "Terraform remote state s3 bucket"
  }
}