output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.main.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.main.arn
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB stream (null when streams disabled)."
  value       = aws_dynamodb_table.main.stream_arn
}

output "contributor_insights_arn" {
  description = "ARN of the CloudWatch Contributor Insights configuration (null when disabled)."
  value = var.contributor_insights_enabled ? format(
    "arn:%s:dynamodb:%s:%s:table/%s/contributorinsights",
    data.aws_partition.current.partition,
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    aws_dynamodb_table.main.name,
  ) : null
}
