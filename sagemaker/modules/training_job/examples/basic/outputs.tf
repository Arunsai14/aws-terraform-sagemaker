output "training_job_name" {
  description = "The name of the training job"
  value       = module.sagemaker_training_job.training_job_name
}

output "training_job_arn" {
  description = "The ARN of the training job"
  value       = module.sagemaker_training_job.training_job_arn
}

output "model_artifacts" {
  description = "The S3 path where model artifacts are stored"
  value       = module.sagemaker_training_job.model_artifacts
}

output "training_job_status" {
  description = "The status of the training job"
  value       = module.sagemaker_training_job.training_job_status
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket used for training data"
  value       = aws_s3_bucket.training_data.bucket
}
