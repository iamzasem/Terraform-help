

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Upload SSH key
resource "aws_key_pair" "deploy" {
  key_name   = "terraform-publickey"
  public_key = file("terraform-publickey.pub")
}

# Use default VPC
resource "aws_default_vpc" "default" {}

# Security group: allow SSH, HTTP, HTTPS
resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow"
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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deploy.key_name

  security_groups = [aws_security_group.allow_user_to_connect.name]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "ZASIM-EC2-Instance"
  }
}
