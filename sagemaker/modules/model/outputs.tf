/**
 * # Outputs for AWS SageMaker Model Module
 */

output "model_id" {
  description = "The name of the model"
  value       = aws_sagemaker_model.this.id
}

output "model_arn" {
  description = "The ARN of the model"
  value       = aws_sagemaker_model.this.arn
}
