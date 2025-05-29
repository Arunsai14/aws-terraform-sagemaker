/**
 * # Outputs for AWS SageMaker Endpoint Configuration Module
 */

output "endpoint_config_id" {
  description = "The name of the endpoint configuration"
  value       = aws_sagemaker_endpoint_configuration.this.id
}

output "endpoint_config_arn" {
  description = "The ARN of the endpoint configuration"
  value       = aws_sagemaker_endpoint_configuration.this.arn
}

output "endpoint_config_name" {
  description = "The name of the endpoint configuration"
  value       = aws_sagemaker_endpoint_configuration.this.name
}
