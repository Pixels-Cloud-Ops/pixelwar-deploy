output "indus_master_public_ip" {
  value = aws_instance.indus_master.public_ip
}

output "indus_workers_public_ips" {
  value = aws_instance.indus_worker[*].public_ip
}