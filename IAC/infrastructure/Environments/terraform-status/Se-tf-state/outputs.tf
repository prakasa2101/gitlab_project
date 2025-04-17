output "s3-bucket-name" {
  value = aws_s3_bucket.tf-state-bucket.id
}

output "dynamodb-table-name" {
  value = aws_dynamodb_table.tf-lock-table.name
}
