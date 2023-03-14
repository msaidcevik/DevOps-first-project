terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

provider "aws" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "tf-sg" {
  name = "roman-sg"
  description = "Allow SSH and HTTP"
  tags = {
    Name = "roman-sg"
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "firstkey"
  security_groups = [ "roman-sg" ]
  tags = {
    Name = "roman-app"
  }

  user_data = "${file("./install-docker.sh")}"
}

output "server_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "server_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}