##############################
#ECloudwatch
##############################

output "cw-eb-arn" {
  description = "The ARN of the cloudwatch log group"
  value       = aws_cloudwatch_log_group.cw-eb.arn
}

output "eb-rule-arn" {
  description = "The ARN of the Eventbridge rule"
  value       = aws_cloudwatch_event_rule.eb-rule.arn
}


