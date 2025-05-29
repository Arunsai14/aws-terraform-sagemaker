/**
 * # AWS SageMaker Serverless Inference Example
 *
 * This example demonstrates how to use the SageMaker module to create a serverless inference endpoint.
 */

provider "aws" {
  region = var.region
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-serverless-role"

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

# Create S3 bucket for model artifacts
resource "aws_s3_bucket" "model_bucket" {
  bucket = "sagemaker-serverless-${random_string.suffix.result}"
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

# Use the SageMaker module
module "sagemaker" {
  source = "../../"

  # Model configuration
  create_model          = true
  model_name            = "serverless-example-model"
  model_execution_role_arn = aws_iam_role.sagemaker_role.arn
  model_primary_container = {
    image = "763104351884.dkr.ecr.${var.region}.amazonaws.com/tensorflow-inference:2.3.0-cpu"
    model_data_url = "s3://${aws_s3_bucket.model_bucket.bucket}/${aws_s3_object.model_artifact.key}"
  }

  # Endpoint Configuration with serverless config
  create_endpoint_config = true
  endpoint_config_name   = "serverless-example-endpoint-config"
  endpoint_config_production_variants = [
    {
      variant_name           = "variant-1"
      model_name             = "serverless-example-model"
      serverless_config = {
        max_concurrency     = 5
        memory_size_in_mb   = 2048
      }
    }
  ]

  # Endpoint
  create_endpoint       = true
  endpoint_name         = "serverless-example-endpoint"

  tags = var.tags

  depends_on = [
    aws_s3_object.model_artifact
  ]
}
