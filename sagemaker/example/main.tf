/**
 * # AWS SageMaker Example
 *
 * This example demonstrates how to use the SageMaker module to create various SageMaker resources
 * including domains, notebooks, models, endpoints, and AI/ML features.
 */

provider "aws" {
  region = var.region
}

# Create IAM role for SageMaker with enhanced permissions
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

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECR-FullAccess"
}

# Create S3 bucket for SageMaker data
resource "aws_s3_bucket" "sagemaker_bucket" {
  bucket = var.sagemaker_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "sagemaker_bucket_ownership" {
  bucket = aws_s3_bucket.sagemaker_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "sagemaker_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.sagemaker_bucket_ownership]
  bucket = aws_s3_bucket.sagemaker_bucket.id
  acl    = "private"
}

# Use existing VPC and subnets
data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_subnet" "private" {
  count = length(var.subnet_ids)
  id    = var.subnet_ids[count.index]
}

# Security group for SageMaker
resource "aws_security_group" "sagemaker_sg" {
  name        = "sagemaker-security-group"
  description = "Security group for SageMaker resources"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Use the SageMaker module
module "sagemaker" {
  source = "../"

  # Domain configuration
  create_domain         = var.create_domain
  domain_name           = var.domain_name
  auth_mode             = var.auth_mode
  vpc_id                = data.aws_vpc.existing.id
  subnet_ids            = var.subnet_ids
  domain_execution_role_arn = aws_iam_role.sagemaker_role.arn
  app_network_access_type = var.app_network_access_type
  domain_security_groups = [aws_security_group.sagemaker_sg.id]
  
  # Studio settings
  jupyter_server_app_settings = {
    default_resource_spec = {
      instance_type = "ml.t3.medium"
    }
  }
  
  kernel_gateway_app_settings = {
    default_resource_spec = {
      instance_type = "ml.t3.medium"
    }
  }

  # Notebook configuration
  create_notebook       = var.create_notebook
  notebook_name         = var.notebook_name
  notebook_role_arn     = aws_iam_role.sagemaker_role.arn
  notebook_instance_type = var.notebook_instance_type
  notebook_volume_size  = var.notebook_volume_size
  notebook_subnet_id    = var.subnet_ids[0]
  notebook_security_groups = [aws_security_group.sagemaker_sg.id]
  notebook_direct_internet_access = "Enabled"
  
  # Lifecycle configuration for notebook
  notebook_lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.notebook_lifecycle.name

  # Model configuration - JumpStart pre-trained model
  create_model          = var.create_model
  model_name            = var.model_name
  model_execution_role_arn = aws_iam_role.sagemaker_role.arn
  model_primary_container = {
    image = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.model_image_uri}"
    model_data_url = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/${var.model_artifact_path}"
    environment = {
      SAGEMAKER_PROGRAM = "inference.py"
      SAGEMAKER_SUBMIT_DIRECTORY = "/opt/ml/model/code"
      SAGEMAKER_CONTAINER_LOG_LEVEL = "20"
    }
  }

  # Endpoint configuration with multiple variants
  create_endpoint_config = true
  endpoint_config_name = var.endpoint_config_name
  endpoint_config_production_variants = [
    {
      variant_name = "default"
      model_name = var.create_model ? module.sagemaker.model_name[0] : var.model_name
      initial_instance_count = var.initial_instance_count
      instance_type = var.instance_type
      initial_variant_weight = 1.0
    },
    {
      variant_name = "serverless"
      model_name = var.create_model ? module.sagemaker.model_name[0] : var.model_name
      serverless_config = {
        max_concurrency = 5
        memory_size_in_mb = 2048
      }
      initial_variant_weight = 0.0
    }
  ]
  
  # Data capture configuration for model monitoring
  endpoint_config_data_capture_config = {
    enable_capture = true
    initial_sampling_percentage = 100
    destination_s3_uri = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/data-capture"
    capture_options = [
      {
        capture_mode = "Input"
      },
      {
        capture_mode = "Output"
      }
    ]
    capture_content_type_header = {
      csv_content_types = ["text/csv"]
      json_content_types = ["application/json"]
    }
  }
  
  # Async inference configuration
  endpoint_config_async_inference_config = {
    output_config = {
      s3_output_path = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/async-results"
      notification_config = {
        success_topic = aws_sns_topic.sagemaker_success.arn
        error_topic = aws_sns_topic.sagemaker_error.arn
      }
    }
    client_config = {
      max_concurrent_invocations_per_instance = 4
    }
  }

  # Endpoint deployment
  create_endpoint = var.create_endpoint
  endpoint_name = var.endpoint_name
  endpoint_deployment_config = {
    blue_green_update_policy = {
      traffic_routing_configuration = {
        type = "ALL_AT_ONCE"
      }
      termination_wait_in_seconds = 300
      maximum_execution_timeout_in_seconds = 1800
    }
    auto_rollback_configuration = {
      alarms = []
    }
  }

  # Code repository for version control
  create_code_repository = var.create_code_repository
  code_repository_name = var.code_repository_name
  code_repository_git_config = {
    repository_url = var.git_repository_url
    branch = var.git_branch
    secret_arn = var.git_secret_arn
  }

  tags = var.tags
}

# SNS topics for async inference notifications
resource "aws_sns_topic" "sagemaker_success" {
  name = "sagemaker-inference-success"
}

resource "aws_sns_topic" "sagemaker_error" {
  name = "sagemaker-inference-error"
}

# Notebook instance lifecycle configuration
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "notebook_lifecycle" {
  name = "sagemaker-notebook-lifecycle"
  on_start = base64encode(<<EOF
#!/bin/bash
set -e

# Install additional packages
sudo -u ec2-user -i <<'EOF2'
pip install --upgrade pip
pip install scikit-learn pandas matplotlib seaborn tensorflow torch transformers datasets
conda install -y -c conda-forge xgboost lightgbm

# Clone example notebooks repository
cd SageMaker
git clone https://github.com/aws/amazon-sagemaker-examples.git

# Set up environment for JupyterLab
jupyter labextension install @jupyter-widgets/jupyterlab-manager
EOF2
EOF
  )
}

# SageMaker Feature Store
resource "aws_sagemaker_feature_group" "example" {
  feature_group_name = "example-feature-group"
  record_identifier_feature_name = "customer_id"
  event_time_feature_name = "timestamp"
  role_arn = aws_iam_role.sagemaker_role.arn
  
  online_store_config {
    enable_online_store = true
  }
  
  offline_store_config {
    s3_storage_config {
      s3_uri = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/feature-store/"
    }
  }
}

# SageMaker Pipeline for MLOps
resource "aws_sagemaker_pipeline" "example" {
  pipeline_name = "example-pipeline"
  pipeline_display_name = "Example ML Pipeline"
  role_arn = aws_iam_role.sagemaker_role.arn
  
  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    Parameters = [
      {
        Name = "InputDataUrl"
        Type = "String"
        DefaultValue = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/input-data/"
      },
      {
        Name = "ModelName"
        Type = "String"
        DefaultValue = var.model_name
      }
    ]
    Steps = [
      {
        Name = "TrainingStep"
        Type = "Training"
        Arguments = {
          AlgorithmSpecification = {
            TrainingImage = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.training_image_uri}"
            TrainingInputMode = "File"
          }
          RoleArn = aws_iam_role.sagemaker_role.arn
          OutputDataConfig = {
            S3OutputPath = "s3://${aws_s3_bucket.sagemaker_bucket.bucket}/training-output/"
          }
          ResourceConfig = {
            InstanceCount = 1
            InstanceType = "ml.m5.xlarge"
            VolumeSizeInGB = 30
          }
          StoppingCondition = {
            MaxRuntimeInSeconds = 86400
          }
          InputDataConfig = [
            {
              ChannelName = "training"
              DataSource = {
                S3DataSource = {
                  S3Uri = "$.Parameters.InputDataUrl"
                  S3DataType = "S3Prefix"
                  S3DataDistributionType = "FullyReplicated"
                }
              }
            }
          ]
        }
      },
      {
        Name = "ModelCreationStep"
        Type = "Model"
        Arguments = {
          ExecutionRoleArn = aws_iam_role.sagemaker_role.arn
          PrimaryContainer = {
            Image = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.model_image_uri}"
            ModelDataUrl = "$.Steps.TrainingStep.TrainingJobName.ModelArtifacts.S3ModelArtifacts"
          }
          ModelName = "$.Parameters.ModelName"
        }
      }
    ]
  })
}
