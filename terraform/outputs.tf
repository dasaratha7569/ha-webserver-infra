output "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.alb.dns_name
}

output "instance_public_ips" {
  description = "Public IPs of Web Servers"
  value       = aws_instance.web[*].public_ip
}

output "instance_ids" {
  description = "EC2 Instance IDs"
  value       = aws_instance.web[*].id
}
