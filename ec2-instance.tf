

# Upload SSH key
resource "aws_key_pair" "deploy" {
  key_name   = "terraform-publickey-new-1-1-1-1"
  public_key = file("terraform-publickey.pub")
}

# Use default VPC
resource "aws_default_vpc" "default" {}

# Security group: allow SSH, HTTP, HTTPS
resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow-new-1-1-1"
  description = "Allow SSH and Web access"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-access"
  }
}

# Create EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deploy.key_name

  security_groups = [aws_security_group.allow_user_to_connect.name]

  root_block_device {
    volume_size =  var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "ZASIM-EC2-Instance"
  }
}

