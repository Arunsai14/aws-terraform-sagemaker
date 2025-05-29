/**
 * # AWS SageMaker Complete Example
 *
 * This example demonstrates how to use the SageMaker module to create a complete SageMaker environment
 * including domain, notebook, model, endpoint configuration, endpoint, and code repository.
 */

provider "aws" {
  region = var.region
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create a VPC for SageMaker
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "sagemaker-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.tags
}

# Create security group for SageMaker
resource "aws_security_group" "sagemaker_sg" {
  name        = "sagemaker-sg"
  description = "Security group for SageMaker resources"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Create a code repository
resource "aws_secretsmanager_secret" "git_credentials" {
  name = "sagemaker-git-credentials"
  description = "Git credentials for SageMaker code repository"
}

resource "aws_secretsmanager_secret_version" "git_credentials" {
  secret_id     = aws_secretsmanager_secret.git_credentials.id
  secret_string = jsonencode({
    username = var.git_username
    password = var.git_password
  })
}

# Use the SageMaker module
module "sagemaker" {
  source = "../../"

  # Domain configuration
  create_domain         = true
  domain_name           = "complete-example-domain"
  auth_mode             = "IAM"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnets
  domain_execution_role_arn = aws_iam_role.sagemaker_role.arn
  app_network_access_type = "PublicInternetOnly"
  domain_security_groups = [aws_security_group.sagemaker_sg.id]
  
  default_user_settings = {
    execution_role = aws_iam_role.sagemaker_role.arn
    security_groups = [aws_security_group.sagemaker_sg.id]
  }

  # Notebook configuration
  create_notebook       = true
  notebook_name         = "complete-example-notebook"
  notebook_role_arn     = aws_iam_role.sagemaker_role.arn
  notebook_instance_type = "ml.t3.medium"
  notebook_volume_size  = 10
  notebook_subnet_id    = module.vpc.private_subnets[0]
  notebook_security_groups = [aws_security_group.sagemaker_sg.id]
  notebook_direct_internet_access = "Enabled"

  # Code Repository configuration
  create_code_repository = true
  code_repository_name   = "complete-example-repo"
  code_repository_git_config = {
    repository_url = var.git_repository_url
    branch         = "main"
    secret_arn     = aws_secretsmanager_secret.git_credentials.arn
  }

  # Model configuration
  create_model          = true
  model_name            = "complete-example-model"
  model_execution_role_arn = aws_iam_role.sagemaker_role.arn
  model_primary_container = {
    image = "763104351884.dkr.ecr.${var.region}.amazonaws.com/tensorflow-inference:2.3.0-cpu"
    model_data_url = "s3://${aws_s3_bucket.model_bucket.bucket}/${aws_s3_object.model_artifact.key}"
  }

  # Endpoint Configuration
  create_endpoint_config = true
  endpoint_config_name   = "complete-example-endpoint-config"
  endpoint_config_production_variants = [
    {
      variant_name           = "variant-1"
      model_name             = "complete-example-model"
      initial_instance_count = 1
      instance_type          = "ml.t2.medium"
      initial_variant_weight = 1.0
    }
  ]
  endpoint_config_data_capture_config = {
    initial_sampling_percentage = 100
    destination_s3_uri          = "s3://${aws_s3_bucket.model_bucket.bucket}/data-capture"
    enable_capture              = true
    capture_options = [
      {
        capture_mode = "Input"
      },
      {
        capture_mode = "Output"
      }
    ]
  }

  # Endpoint
  create_endpoint       = true
  endpoint_name         = "complete-example-endpoint"
  
  # Deployment configuration for blue/green deployment
  endpoint_deployment_config = {
    blue_green_update_policy = {
      traffic_routing_configuration = {
        type                     = "ALL_AT_ONCE"
        wait_interval_in_seconds = 600
      }
      termination_wait_in_seconds = 600
    }
  }

  tags = var.tags

  depends_on = [
    aws_secretsmanager_secret_version.git_credentials,
    aws_s3_object.model_artifact
  ]
}

# Create S3 bucket for model artifacts
resource "aws_s3_bucket" "model_bucket" {
  bucket = "sagemaker-model-artifacts-${random_string.suffix.result}"
  force_destroy = true
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

# Upload a dummy model artifact
resource "aws_s3_object" "model_artifact" {
  bucket = aws_s3_bucket.model_bucket.bucket
  key    = "model/model.tar.gz"
  source = "${path.module}/dummy_model.tar.gz"
  etag   = filemd5("${path.module}/dummy_model.tar.gz")
}
