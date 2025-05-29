/**
 * # Outputs for AWS SageMaker Code Repository Module
 */

output "code_repository_id" {
  description = "The name of the Code Repository"
  value       = aws_sagemaker_code_repository.this.id
}

output "code_repository_arn" {
  description = "The ARN of the Code Repository"
  value       = aws_sagemaker_code_repository.this.arn
}
