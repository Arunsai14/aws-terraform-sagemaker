/**
 * # Outputs for AWS SageMaker Asynchronous Inference Example
 */

output "sagemaker_role_arn" {
  description = "The ARN of the IAM role for SageMaker"
  value       = aws_iam_role.sagemaker_role.arn
}

output "model_bucket_name" {
  description = "The name of the S3 bucket for model artifacts"
  value       = aws_s3_bucket.model_bucket.bucket
}

output "success_topic_arn" {
  description = "The ARN of the SNS topic for successful inferences"
  value       = aws_sns_topic.success_topic.arn
}

output "error_topic_arn" {
  description = "The ARN of the SNS topic for failed inferences"
  value       = aws_sns_topic.error_topic.arn
}

# Model outputs
output "model_id" {
  description = "The name of the model"
  value       = module.sagemaker.model_id
}

output "model_arn" {
  description = "The ARN of the model"
  value       = module.sagemaker.model_arn
}

# Endpoint Configuration outputs
output "endpoint_config_id" {
  description = "The name of the endpoint configuration"
  value       = module.sagemaker.endpoint_config_id
}

output "endpoint_config_arn" {
  description = "The ARN of the endpoint configuration"
  value       = module.sagemaker.endpoint_config_arn
}

# Endpoint outputs
output "endpoint_id" {
  description = "The name of the endpoint"
  value       = module.sagemaker.endpoint_id
}

output "endpoint_arn" {
  description = "The ARN of the endpoint"
  value       = module.sagemaker.endpoint_arn
}
