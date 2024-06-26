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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_key_pair" "my_keypair" {
  key_name   = "ec2-polkadot-node-keypair"
  public_key = var.public_key
}

resource "aws_instance" "pd_node" {
  count         = 2
  ami           = "ami-0cf2b4e024cdb6960"
  instance_type = "t2.micro" 

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  key_name = "ec2-polkadot-node-keypair"

  vpc_security_group_ids = [aws_security_group.allow_ping.id, aws_security_group.allow_ssh.id]

  tags = {
    Name = "PolkadotNode${count.index + 1}"
  }
}
