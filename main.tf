data "aws_ami" "ubuntu_jammy" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow inbound Strapi and SSH"

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi_ec2" {
  ami                         = data.aws_ami.ubuntu_jammy.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.sh", {
    docker_tag = var.docker_image_tag
  })

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  tags = {
    Name = "EC2-Rohana-Upadhyay"
  }
}

output "ec2_public_ip" {
  value = aws_instance.strapi_ec2.public_ip
}

