output "rds_endpoint" {
  description = "Endpoint RDS a utiliser dans le secret K3s"
  value       = aws_db_instance.pixelwar_postgres.endpoint
}