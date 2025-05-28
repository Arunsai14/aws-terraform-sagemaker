output "model_arn" {
  value       = aws_sagemaker_model.this.arn
  description = "The ARN of the created SageMaker model"
}

output "model_name" {
  value       = aws_sagemaker_model.this.name
  description = "The name of the created SageMaker model"
}


############################################################
############################################################

output "arn" {
  description = "The ARN assigned by AWS to this endpoint configuration."
  value       = aws_sagemaker_endpoint_configuration.this.arn
}

output "name" {
  description = "The name of the endpoint configuration."
  value       = aws_sagemaker_endpoint_configuration.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider."
  value       = aws_sagemaker_endpoint_configuration.this.tags_all
}

#############################################################

output "sagemaker_endpoint_arn" {
  description = "ARN of the SageMaker endpoint"
  value       = aws_sagemaker_endpoint.this.arn
}

output "sagemaker_endpoint_name" {
  description = "Name of the SageMaker endpoint"
  value       = aws_sagemaker_endpoint.this.name
}

output "sagemaker_endpoint_tags_all" {
  description = "All tags including inherited"
  value       = aws_sagemaker_endpoint.this.tags_all
}