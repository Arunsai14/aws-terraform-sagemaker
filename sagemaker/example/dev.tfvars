# AWS Region
region      = "us-east-1"
environment = "dev"
namespace   = "arc"

# Tags
tags = {
  Environment = "dev"
  Project     = "SageMaker-AI"
  Owner       = "Data-Science-Team"
  ManagedBy   = "Terraform"
}

# Existing VPC and Subnets
vpc_id = "vpc-0e6c09980580ecbf6"  # Replace with your actual VPC ID
subnet_ids = ["subnet-066d0c78479b72e77", "subnet-064b80a494fed9835"]  # Replace with your actual subnet IDs

# SageMaker Domain
create_domain = true
domain_name = "sagemaker-ai-domain"
auth_mode = "IAM"
app_network_access_type = "PublicInternetOnly"

# SageMaker Notebook
create_notebook = true
notebook_name = "sagemaker-ai-notebook"
notebook_instance_type = "ml.t3.large"
notebook_volume_size = 100

# SageMaker Model
create_model = true
model_name = "sagemaker-ai-model"
# Replace with your actual account ID
account_id = "884360309640"  # Replace this with your actual AWS account ID
model_image_uri = "sagemaker-model-image:latest"
model_artifact_path = "models/model.tar.gz"

# SageMaker Endpoint
create_endpoint = true
endpoint_name = "sagemaker-ai-endpoint"
endpoint_config_name = "sagemaker-ai-endpoint-config"
initial_instance_count = 1
instance_type = "ml.m5.large"

# S3 Bucket
sagemaker_bucket_name = "sagemaker-ai-bucket-sf68335"  # Replace with a globally unique bucket name

# Code Repository
create_code_repository = false
code_repository_name = "sagemaker-ai-code-repo"
git_repository_url = "https://github.com/example/sagemaker-repo.git"
git_branch = "main"
# Leave empty if not using Git authentication
git_secret_arn = ""

# Training Image
training_image_uri = "sagemaker-training-image:latest"
