variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_public" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vpc_cidr_private" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}




variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}