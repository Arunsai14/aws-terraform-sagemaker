variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "SageMaker-Example"
  }
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet IDs to use"
  type        = list(string)
}

variable "create_domain" {
  description = "Whether to create a SageMaker domain"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Name of the SageMaker domain"
  type        = string
  default     = "sagemaker-domain"
}

variable "auth_mode" {
  description = "Authentication mode for the domain"
  type        = string
  default     = "IAM"
}

variable "app_network_access_type" {
  description = "Network access type for the domain"
  type        = string
  default     = "PublicInternetOnly"
}

variable "create_notebook" {
  description = "Whether to create a SageMaker notebook instance"
  type        = bool
  default     = true
}

variable "notebook_name" {
  description = "Name of the SageMaker notebook instance"
  type        = string
  default     = "sagemaker-notebook"
}

variable "notebook_instance_type" {
  description = "Instance type for the notebook"
  type        = string
  default     = "ml.t3.medium"
}

variable "notebook_volume_size" {
  description = "Volume size for the notebook in GB"
  type        = number
  default     = 50
}

variable "create_model" {
  description = "Whether to create a SageMaker model"
  type        = bool
  default     = true
}

variable "model_name" {
  description = "Name of the SageMaker model"
  type        = string
  default     = "sagemaker-model"
}

variable "model_primary_container" {
  description = "Primary container for the model"
  type        = any
  default     = {
    image = "763104351884.dkr.ecr.us-east-1.amazonaws.com/tensorflow-inference:2.8.0-cpu"
  }
}

variable "create_endpoint" {
  description = "Whether to create a SageMaker endpoint"
  type        = bool
  default     = true
}

variable "endpoint_name" {
  description = "Name of the SageMaker endpoint"
  type        = string
  default     = "sagemaker-endpoint"
}

variable "endpoint_config_name" {
  description = "Name of the SageMaker endpoint configuration"
  type        = string
  default     = "sagemaker-endpoint-config"
}

variable "sagemaker_bucket_name" {
  description = "Name of the S3 bucket for SageMaker data"
  type        = string
  default     = "sagemaker-example-bucket-unique-name"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = "123456789012"
}

variable "model_image_uri" {
  description = "URI of the model image in ECR"
  type        = string
  default     = "sagemaker-model-image:latest"
}

variable "model_artifact_path" {
  description = "Path to the model artifacts in S3"
  type        = string
  default     = "models/model.tar.gz"
}

variable "initial_instance_count" {
  description = "Initial instance count for the endpoint"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for the endpoint"
  type        = string
  default     = "ml.m5.large"
}

variable "create_code_repository" {
  description = "Whether to create a SageMaker code repository"
  type        = bool
  default     = false
}

variable "code_repository_name" {
  description = "Name of the SageMaker code repository"
  type        = string
  default     = "sagemaker-code-repo"
}

variable "git_repository_url" {
  description = "URL of the Git repository"
  type        = string
  default     = "https://github.com/example/sagemaker-repo.git"
}

variable "git_branch" {
  description = "Branch of the Git repository"
  type        = string
  default     = "main"
}

variable "git_secret_arn" {
  description = "ARN of the secret containing Git credentials"
  type        = string
  default     = ""
}

variable "training_image_uri" {
  description = "URI of the training image in ECR"
  type        = string
  default     = "sagemaker-training-image:latest"
}
