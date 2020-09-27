terraform {
    backend "s3" {
        bucket = "benmangold-tf-state-bucket"
        key = "globals/s3/terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "benmangold-tf-state-lock-table"
        encrypt= "true"
    }
}

variable "key_name" {
    description = "AWS key name used for SSH access"
    type = string
}

variable "instance_name" {
    description = "Value for EC2 Instance 'Name' tag key"
    type = string
}

provider "aws" {
    region = "us-east-2"
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "dev_server_role_dev_env" {
    image_id = data.aws_ami.ubuntu.id
    instance_type = "t2.medium"
    key_name = var.key_name
    security_groups = [aws_security_group.instance.id]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "dev_server_role_dev_env" {
    launch_configuration = aws_launch_configuration.dev_server_role_dev_env.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    min_size = 1
    max_size = 1

    tag {
        key = "Name"
        value = var.instance_name
        propagate_at_launch = true
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    ingress {
        from_port  = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ingress from ssh"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
