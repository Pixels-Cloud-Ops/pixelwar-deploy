variable "aws_region" {
  description = "Région AWS pour le déploiement"
  type        = string
  default     = "eu-west-3"
}

variable "db_username" {
  description = "Username PostgreSQL"
  type        = string
  default     = "admindb"
}

variable "db_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  sensitive   = true
}