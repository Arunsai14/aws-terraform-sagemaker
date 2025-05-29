/**
 * # Outputs for AWS SageMaker Module
 */

# Domain outputs
output "domain_id" {
  description = "The ID of the SageMaker domain"
  value       = var.create_domain ? module.sagemaker_domain[0].domain_id : null
}

output "domain_arn" {
  description = "The ARN of the SageMaker domain"
  value       = var.create_domain ? module.sagemaker_domain[0].domain_arn : null
}

output "domain_url" {
  description = "The domain's URL"
  value       = var.create_domain ? module.sagemaker_domain[0].domain_url : null
}

output "domain_home_efs_file_system_id" {
  description = "The ID of the Amazon Elastic File System (EFS) managed by this domain"
  value       = var.create_domain ? module.sagemaker_domain[0].home_efs_file_system_id : null
}

# Notebook outputs
output "notebook_id" {
  description = "The name of the notebook instance"
  value       = var.create_notebook ? module.sagemaker_notebook[0].notebook_id : null
}

output "notebook_arn" {
  description = "The ARN of the notebook instance"
  value       = var.create_notebook ? module.sagemaker_notebook[0].notebook_arn : null
}

output "notebook_url" {
  description = "The URL that you use to connect to the Jupyter notebook"
  value       = var.create_notebook ? module.sagemaker_notebook[0].notebook_url : null
}

# Model outputs
output "model_id" {
  description = "The name of the model"
  value       = var.create_model ? module.sagemaker_model[0].model_id : null
}

output "model_arn" {
  description = "The ARN of the model"
  value       = var.create_model ? module.sagemaker_model[0].model_arn : null
}

# Endpoint Configuration outputs
output "endpoint_config_id" {
  description = "The name of the endpoint configuration"
  value       = var.create_endpoint_config ? module.sagemaker_endpoint_configuration[0].endpoint_config_id : null
}

output "endpoint_config_arn" {
  description = "The ARN of the endpoint configuration"
  value       = var.create_endpoint_config ? module.sagemaker_endpoint_configuration[0].endpoint_config_arn : null
}

output "endpoint_config_name" {
  description = "The name of the endpoint configuration"
  value       = var.create_endpoint_config ? module.sagemaker_endpoint_configuration[0].endpoint_config_name : null
}

# Endpoint outputs
output "endpoint_id" {
  description = "The name of the endpoint"
  value       = var.create_endpoint ? module.sagemaker_endpoint[0].endpoint_id : null
}

output "endpoint_arn" {
  description = "The ARN of the endpoint"
  value       = var.create_endpoint ? module.sagemaker_endpoint[0].endpoint_arn : null
}

# Code Repository outputs
output "code_repository_id" {
  description = "The name of the Code Repository"
  value       = var.create_code_repository ? module.sagemaker_code_repository[0].code_repository_id : null
}

output "code_repository_arn" {
  description = "The ARN of the Code Repository"
  value       = var.create_code_repository ? module.sagemaker_code_repository[0].code_repository_arn : null
}
