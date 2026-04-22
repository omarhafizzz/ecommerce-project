terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# ─── Key Pair ───────────────────────────────────────────────
resource "aws_key_pair" "luxe" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)
}

# ─── VPC & Networking ───────────────────────────────────────
resource "aws_vpc" "luxe" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "${var.project_name}-vpc" }
}

resource "aws_internet_gateway" "luxe" {
  vpc_id = aws_vpc.luxe.id
  tags   = { Name = "${var.project_name}-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.luxe.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = { Name = "${var.project_name}-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.luxe.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.luxe.id
  }
  tags = { Name = "${var.project_name}-rt" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ─── Security Group ─────────────────────────────────────────
resource "aws_security_group" "luxe" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH, HTTP for LUXE app"
  vpc_id      = aws_vpc.luxe.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP Frontend"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Frontend alt port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg" }
}

# ─── Elastic IP ─────────────────────────────────────────────
resource "aws_eip" "luxe" {
  domain   = "vpc"
  instance = aws_instance.luxe.id
  tags     = { Name = "${var.project_name}-eip" }
}

# ─── EC2 Instance ───────────────────────────────────────────
data "aws_ami" "ubuntu" {
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

resource "aws_instance" "luxe" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.luxe.id]
  key_name               = aws_key_pair.luxe.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/userdata.sh", {
    github_repo  = var.github_repo
    jwt_secret   = var.jwt_secret
    db_password  = var.db_password
  })

  tags = { Name = "${var.project_name}-server" }
}
