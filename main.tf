terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "pdn1" {
  ami           = "ami-0eb9d67c52f5c80e5"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 30
    volume_type = "gp3"

  }

  tags = {
    Name = "PolkadotNode1"
  }
}