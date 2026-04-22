output "elastic_ip" {
  description = "Public IP of the server"
  value       = aws_eip.luxe.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.luxe.id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.luxe.public_ip}"
}

output "app_url" {
  description = "URL to access the app"
  value       = "http://${aws_eip.luxe.public_ip}:3000"
}
