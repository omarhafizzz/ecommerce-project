variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "luxe"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "My_Key"
}

variable "ssh_allowed_cidr" {
  description = "Your IP for SSH access (e.g. 1.2.3.4/32). Use 0.0.0.0/0 for any IP."
  type        = string
  default     = "0.0.0.0/0"
}

variable "github_repo" {
  description = "GitHub repo URL to clone (e.g. https://github.com/user/ecommerce)"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret for the backend (use a strong random string)"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}
variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID"
  type        = string
  default     = "ami-0faab6bdbac9486fb" # eu-central-1 Ubuntu 22.04
}