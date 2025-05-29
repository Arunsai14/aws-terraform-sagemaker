/**
 * # Outputs for AWS SageMaker Endpoint Module
 */

output "endpoint_id" {
  description = "The name of the endpoint"
  value       = aws_sagemaker_endpoint.this.id
}

output "endpoint_arn" {
  description = "The ARN of the endpoint"
  value       = aws_sagemaker_endpoint.this.arn
}
