/**
 * # AWS SageMaker Asynchronous Inference Example
 *
 * This example demonstrates how to use the SageMaker module to create an asynchronous inference endpoint.
 */

provider "aws" {
  region = var.region
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-async-role"

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

# Create S3 bucket for model artifacts and inference results
resource "aws_s3_bucket" "model_bucket" {
  bucket = "sagemaker-async-${random_string.suffix.result}"
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

# Create SNS topics for success and error notifications
resource "aws_sns_topic" "success_topic" {
  name = "sagemaker-async-success"
}

resource "aws_sns_topic" "error_topic" {
  name = "sagemaker-async-error"
}

# Use the SageMaker module
module "sagemaker" {
  source = "../../"

  # Model configuration
  create_model          = true
  model_name            = "async-example-model"
  model_execution_role_arn = aws_iam_role.sagemaker_role.arn
  model_primary_container = {
    image = "763104351884.dkr.ecr.${var.region}.amazonaws.com/tensorflow-inference:2.3.0-cpu"
    model_data_url = "s3://${aws_s3_bucket.model_bucket.bucket}/${aws_s3_object.model_artifact.key}"
  }

  # Endpoint Configuration with async inference config
  create_endpoint_config = true
  endpoint_config_name   = "async-example-endpoint-config"
  endpoint_config_production_variants = [
    {
      variant_name           = "variant-1"
      model_name             = "async-example-model"
      initial_instance_count = 1
      instance_type          = "ml.m5.large"
    }
  ]
  endpoint_config_async_inference_config = {
    output_config = {
      s3_output_path = "s3://${aws_s3_bucket.model_bucket.bucket}/async-results/"
      s3_failure_path = "s3://${aws_s3_bucket.model_bucket.bucket}/async-failures/"
      notification_config = {
        success_topic = aws_sns_topic.success_topic.arn
        error_topic = aws_sns_topic.error_topic.arn
        include_inference_response_in = ["SUCCESS_NOTIFICATION_TOPIC"]
      }
    }
    client_config = {
      max_concurrent_invocations_per_instance = 4
    }
  }

  # Endpoint
  create_endpoint       = true
  endpoint_name         = "async-example-endpoint"

  tags = var.tags

  depends_on = [
    aws_s3_object.model_artifact
  ]
}
