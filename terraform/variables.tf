variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "highly-available-web-app"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "lab"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Existing EC2 Key Pair"
  type        = string
}

variable "web_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 4
}