output "rails_app_role_arn" {
  description = "ARN of the Rails app IAM role"
  value       = aws_iam_role.rails_app_service_account.arn
}

output "rails_app_role_name" {
  description = "Name of the Rails app IAM role"
  value       = aws_iam_role.rails_app_service_account.name
}
