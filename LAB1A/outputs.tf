output "ec2_public_ip" {
  value = aws_instance.my_ec2
  description = "The public IP address of the ec2 instances"
}