output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.existing.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = var.subnet_ids
}

output "sagemaker_role_arn" {
  description = "ARN of the SageMaker execution role"
  value       = aws_iam_role.sagemaker_role.arn
}

output "sagemaker_bucket_name" {
  description = "Name of the S3 bucket for SageMaker data"
  value       = aws_s3_bucket.sagemaker_bucket.bucket
}

output "sagemaker_bucket_arn" {
  description = "ARN of the S3 bucket for SageMaker data"
  value       = aws_s3_bucket.sagemaker_bucket.arn
}

output "sagemaker_domain_id" {
  description = "ID of the SageMaker domain"
  value       = var.create_domain ? module.sagemaker.domain_id[0] : null
}

output "sagemaker_domain_url" {
  description = "URL of the SageMaker domain"
  value       = var.create_domain ? module.sagemaker.domain_url[0] : null
}

output "notebook_instance_name" {
  description = "Name of the SageMaker notebook instance"
  value       = var.create_notebook ? module.sagemaker.notebook_name[0] : null
}

output "notebook_instance_url" {
  description = "URL of the SageMaker notebook instance"
  value       = var.create_notebook ? module.sagemaker.notebook_url[0] : null
}

output "model_name" {
  description = "Name of the SageMaker model"
  value       = var.create_model ? module.sagemaker.model_name[0] : null
}

output "model_arn" {
  description = "ARN of the SageMaker model"
  value       = var.create_model ? module.sagemaker.model_arn[0] : null
}

output "endpoint_config_name" {
  description = "Name of the SageMaker endpoint configuration"
  value       = var.create_endpoint_config ? module.sagemaker.endpoint_config_name[0] : null
}

output "endpoint_config_arn" {
  description = "ARN of the SageMaker endpoint configuration"
  value       = var.create_endpoint_config ? module.sagemaker.endpoint_config_arn[0] : null
}

output "endpoint_name" {
  description = "Name of the SageMaker endpoint"
  value       = var.create_endpoint ? module.sagemaker.endpoint_name[0] : null
}

output "endpoint_arn" {
  description = "ARN of the SageMaker endpoint"
  value       = var.create_endpoint ? module.sagemaker.endpoint_arn[0] : null
}

output "feature_group_name" {
  description = "Name of the SageMaker feature group"
  value       = aws_sagemaker_feature_group.example.feature_group_name
}

output "feature_group_arn" {
  description = "ARN of the SageMaker feature group"
  value       = aws_sagemaker_feature_group.example.arn
}

output "pipeline_name" {
  description = "Name of the SageMaker pipeline"
  value       = aws_sagemaker_pipeline.example.pipeline_name
}

output "pipeline_arn" {
  description = "ARN of the SageMaker pipeline"
  value       = aws_sagemaker_pipeline.example.arn
}

output "sns_success_topic_arn" {
  description = "ARN of the SNS topic for successful inferences"
  value       = aws_sns_topic.sagemaker_success.arn
}

output "sns_error_topic_arn" {
  description = "ARN of the SNS topic for failed inferences"
  value       = aws_sns_topic.sagemaker_error.arn
}

output "code_repository_name" {
  description = "Name of the SageMaker code repository"
  value       = var.create_code_repository ? module.sagemaker.code_repository_name[0] : null
}

output "code_repository_arn" {
  description = "ARN of the SageMaker code repository"
  value       = var.create_code_repository ? module.sagemaker.code_repository_arn[0] : null
}
