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

resource "aws_security_group" "allow_ping" {
  name        = "allow_ping"
  description = "Allow ICMP traffic for ping"

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ping"
  }
}

resource "aws_instance" "pdn1" {
  ami           = "ami-0eb9d67c52f5c80e5"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.allow_ping.id]

  tags = {
    Name = "PolkadotNode1"
  }
}