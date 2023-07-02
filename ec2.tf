data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "florence" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone


  tags = {
    Service = var.service_name
  }
}

resource "aws_security_group" "allow_users" {
  name        = "allow_users"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "External SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.user_addresses
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Service = var.service_name
  }
}

resource "aws_instance" "florence" {
  # get Amazon Linux 2 AMI
  ami                         = data.aws_ami.amazon-2.id
  subnet_id                   = aws_subnet.florence.id
  associate_public_ip_address = true

  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance.id
  key_name             = aws_key_pair.markh.key_name

  security_groups = [aws_security_group.allow_users.id]
  tags = {
    Service = var.service_name
  }
}

resource "aws_key_pair" "markh" {
  key_name   = "markh-key"
  public_key = var.my_public_key
}