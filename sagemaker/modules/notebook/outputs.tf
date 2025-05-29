/**
 * # Outputs for AWS SageMaker Notebook Instance Module
 */

output "notebook_id" {
  description = "The name of the notebook instance"
  value       = aws_sagemaker_notebook_instance.this.id
}

output "notebook_arn" {
  description = "The ARN of the notebook instance"
  value       = aws_sagemaker_notebook_instance.this.arn
}

output "notebook_url" {
  description = "The URL that you use to connect to the Jupyter notebook"
  value       = aws_sagemaker_notebook_instance.this.url
}

output "network_interface_id" {
  description = "The network interface ID that Amazon SageMaker created at the time of creating the instance"
  value       = aws_sagemaker_notebook_instance.this.network_interface_id
}
