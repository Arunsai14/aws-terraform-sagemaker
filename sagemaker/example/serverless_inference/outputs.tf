/**
 * # Outputs for AWS SageMaker Serverless Inference Example
 */

output "sagemaker_role_arn" {
  description = "The ARN of the IAM role for SageMaker"
  value       = aws_iam_role.sagemaker_role.arn
}

output "model_bucket_name" {
  description = "The name of the S3 bucket for model artifacts"
  value       = aws_s3_bucket.model_bucket.bucket
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
