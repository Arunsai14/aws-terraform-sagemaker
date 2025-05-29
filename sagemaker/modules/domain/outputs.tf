/**
 * # Outputs for AWS SageMaker Domain Module
 */

output "domain_id" {
  description = "The ID of the SageMaker domain"
  value       = aws_sagemaker_domain.this.id
}

output "domain_arn" {
  description = "The ARN of the SageMaker domain"
  value       = aws_sagemaker_domain.this.arn
}

output "domain_url" {
  description = "The domain's URL"
  value       = aws_sagemaker_domain.this.url
}

output "home_efs_file_system_id" {
  description = "The ID of the Amazon Elastic File System (EFS) managed by this domain"
  value       = aws_sagemaker_domain.this.home_efs_file_system_id
}

output "security_group_id_for_domain_boundary" {
  description = "The ID of the security group that authorizes traffic between the RSessionGateway apps and the RStudioServerPro app"
  value       = aws_sagemaker_domain.this.security_group_id_for_domain_boundary
}
