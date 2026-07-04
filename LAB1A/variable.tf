variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The aws region where resources  will be created "
}

variable "ec2_ami" {
  type        = string
  default     = "ami-00b2eb779cc80e1f9"
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The instance type for the ec2 instance"

}