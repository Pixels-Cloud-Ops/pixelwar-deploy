output "prod_master_public_ip" {
  value = aws_instance.prod_master.public_ip
}

output "prod_workers_public_ips" {
  value = aws_instance.prod_worker[*].public_ip
}