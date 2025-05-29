provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "sagemaker_execution_role" {
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

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_s3_bucket" "training_data" {
  bucket = "sagemaker-training-data-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "sagemaker_training_job" {
  source = "../../"

  training_job_name = "example-training-job-${random_id.suffix.hex}"
  role_arn          = aws_iam_role.sagemaker_execution_role.arn
  
  algorithm_specification = {
    training_image      = "683313688378.dkr.ecr.us-west-2.amazonaws.com/sagemaker-xgboost:1.3-1"
    training_input_mode = "File"
  }
  
  input_data_config = [
    {
      channel_name = "train"
      data_source = {
        s3_data_source = {
          s3_data_type = "S3Prefix"
          s3_uri       = "${aws_s3_bucket.training_data.bucket_domain_name}/train/"
        }
      }
    },
    {
      channel_name = "validation"
      data_source = {
        s3_data_source = {
          s3_data_type = "S3Prefix"
          s3_uri       = "${aws_s3_bucket.training_data.bucket_domain_name}/validation/"
        }
      }
    }
  ]
  
  output_data_config = {
    s3_output_path = "s3://${aws_s3_bucket.training_data.bucket}/output/"
  }
  
  resource_config = {
    instance_type     = "ml.m5.large"
    instance_count    = 1
    volume_size_in_gb = 30
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 3600
  }
  
  hyper_parameters = {
    "max_depth" = "5"
    "eta" = "0.2"
    "gamma" = "4"
    "min_child_weight" = "6"
    "subsample" = "0.8"
    "objective" = "binary:logistic"
    "num_round" = "100"
  }
  
  tags = {
    Environment = "dev"
    Project     = "ml-pipeline"
  }
}
