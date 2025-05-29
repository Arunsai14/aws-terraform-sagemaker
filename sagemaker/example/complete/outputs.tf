/**
 * # Outputs for AWS SageMaker Complete Example
 */

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "sagemaker_role_arn" {
  description = "The ARN of the IAM role for SageMaker"
  value       = aws_iam_role.sagemaker_role.arn
}

output "model_bucket_name" {
  description = "The name of the S3 bucket for model artifacts"
  value       = aws_s3_bucket.model_bucket.bucket
}

# Domain outputs
output "domain_id" {
  description = "The ID of the SageMaker domain"
  value       = module.sagemaker.domain_id
}

output "domain_arn" {
  description = "The ARN of the SageMaker domain"
  value       = module.sagemaker.domain_arn
}

output "domain_url" {
  description = "The domain's URL"
  value       = module.sagemaker.domain_url
}

# Notebook outputs
output "notebook_id" {
  description = "The name of the notebook instance"
  value       = module.sagemaker.notebook_id
}

output "notebook_arn" {
  description = "The ARN of the notebook instance"
  value       = module.sagemaker.notebook_arn
}

output "notebook_url" {
  description = "The URL that you use to connect to the Jupyter notebook"
  value       = module.sagemaker.notebook_url
}

# Code Repository outputs
output "code_repository_id" {
  description = "The name of the Code Repository"
  value       = module.sagemaker.code_repository_id
}

output "code_repository_arn" {
  description = "The ARN of the Code Repository"
  value       = module.sagemaker.code_repository_arn
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
