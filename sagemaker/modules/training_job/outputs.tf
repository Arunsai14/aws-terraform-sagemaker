output "training_job_name" {
  description = "The name of the training job"
  value       = aws_sagemaker_training_job.this.training_job_name
}

output "training_job_arn" {
  description = "The ARN of the training job"
  value       = aws_sagemaker_training_job.this.arn
}

output "model_artifacts" {
  description = "The S3 path where model artifacts are stored"
  value       = aws_sagemaker_training_job.this.model_artifact_url
}

output "training_job_status" {
  description = "The status of the training job"
  value       = aws_sagemaker_training_job.this.training_job_status
}

output "secondary_status" {
  description = "The secondary status of the training job"
  value       = aws_sagemaker_training_job.this.secondary_status
}

output "creation_time" {
  description = "The time when the training job was created"
  value       = aws_sagemaker_training_job.this.creation_time
}

output "training_end_time" {
  description = "The time when the training job ended"
  value       = aws_sagemaker_training_job.this.training_end_time
}

output "last_modified_time" {
  description = "The time when the training job was last modified"
  value       = aws_sagemaker_training_job.this.last_modified_time
}

output "billable_time_in_seconds" {
  description = "The billable time in seconds for the training job"
  value       = aws_sagemaker_training_job.this.billable_time_in_seconds
}
