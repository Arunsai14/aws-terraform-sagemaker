output "processing_job_name" {
  description = "The name of the processing job"
  value       = aws_sagemaker_processing_job.this.processing_job_name
}

output "processing_job_arn" {
  description = "The ARN of the processing job"
  value       = aws_sagemaker_processing_job.this.arn
}

output "creation_time" {
  description = "The time when the processing job was created"
  value       = aws_sagemaker_processing_job.this.creation_time
}

output "processing_end_time" {
  description = "The time when the processing job ended"
  value       = aws_sagemaker_processing_job.this.processing_end_time
}

output "last_modified_time" {
  description = "The time when the processing job was last modified"
  value       = aws_sagemaker_processing_job.this.last_modified_time
}

output "processing_job_status" {
  description = "The status of the processing job"
  value       = aws_sagemaker_processing_job.this.processing_job_status
}

output "failure_reason" {
  description = "The reason the processing job failed, if it failed"
  value       = aws_sagemaker_processing_job.this.failure_reason
}
