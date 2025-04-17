output "rds_username" {
  description = "RDS username"
  value = jsondecode(aws_secretsmanager_secret_version.sversion.secret_string).username
  sensitive = true
}

output "rds_password" {
  description = "RDS username"
  value = jsondecode(aws_secretsmanager_secret_version.sversion.secret_string).password
  sensitive = true
}

output "secret-arn" {
  value = aws_secretsmanager_secret.secretmasterDB.arn
} 

output "aws_db_instance" {
  description = "The connection endpoint"
  value       = aws_db_instance.rds.endpoint
}

