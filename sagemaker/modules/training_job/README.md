# AWS SageMaker Training Job Module

This Terraform module creates an AWS SageMaker Training Job with configurable settings.

## Features

- Creates a SageMaker training job with customizable configuration
- Supports algorithm specification with custom training images or built-in algorithms
- Configurable input and output data sources
- Customizable resource allocation (instance type, count, volume size)
- Support for hyperparameter configuration
- Checkpoint configuration for training job state persistence
- Debug hook configuration for monitoring training metrics
- TensorBoard integration for visualization
- Experiment tracking integration

## Usage

```hcl
module "sagemaker_training_job" {
  source = "path/to/modules/training_job"

  training_job_name = "example-training-job"
  role_arn          = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
  
  algorithm_specification = {
    training_image      = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-training-image:latest"
    training_input_mode = "File"
  }
  
  input_data_config = [
    {
      channel_name = "training"
      data_source = {
        s3_data_source = {
          s3_data_type = "S3Prefix"
          s3_uri       = "s3://my-bucket/training-data/"
        }
      }
      content_type = "text/csv"
    }
  ]
  
  output_data_config = {
    s3_output_path = "s3://my-bucket/output/"
  }
  
  resource_config = {
    instance_type     = "ml.m5.large"
    instance_count    = 1
    volume_size_in_gb = 50
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 3600
  }
  
  hyper_parameters = {
    "learning_rate" = "0.01"
    "batch_size"    = "64"
    "epochs"        = "10"
  }
  
  tags = {
    Environment = "dev"
    Project     = "ml-pipeline"
  }
}
```

## Examples

### Basic Training Job

```hcl
module "basic_training_job" {
  source = "path/to/modules/training_job"

  training_job_name = "basic-training-job"
  role_arn          = aws_iam_role.sagemaker_execution_role.arn
  
  algorithm_specification = {
    training_image      = "amazonaws.com/sagemaker-xgboost:1.0-1"
    training_input_mode = "File"
  }
  
  input_data_config = [
    {
      channel_name = "train"
      data_source = {
        s3_data_source = {
          s3_data_type = "S3Prefix"
          s3_uri       = "s3://my-bucket/train/"
        }
      }
    },
    {
      channel_name = "validation"
      data_source = {
        s3_data_source = {
          s3_data_type = "S3Prefix"
          s3_uri       = "s3://my-bucket/validation/"
        }
      }
    }
  ]
  
  output_data_config = {
    s3_output_path = "s3://my-bucket/output/"
  }
  
  resource_config = {
    instance_type     = "ml.m5.large"
    instance_count    = 1
    volume_size_in_gb = 30
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 3600
  }
}
```

### Training Job with Experiment Tracking

```hcl
module "experiment_training_job" {
  source = "path/to/modules/training_job"

  training_job_name = "experiment-training-job"
  role_arn          = aws_iam_role.sagemaker_execution_role.arn
  
  algorithm_specification = {
    training_image      = "amazonaws.com/sagemaker-tensorflow:2.3.0-cpu-py37"
    training_input_mode = "File"
  }
  
  input_data_config = [
    {
      channel_name = "training"
      data_source = {
        s3_data_source = {
          s3_data_type = "S3Prefix"
          s3_uri       = "s3://my-bucket/training-data/"
        }
      }
    }
  ]
  
  output_data_config = {
    s3_output_path = "s3://my-bucket/output/"
  }
  
  resource_config = {
    instance_type     = "ml.m5.xlarge"
    instance_count    = 1
    volume_size_in_gb = 50
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 7200
  }
  
  experiment_config = {
    experiment_name = "my-experiment"
    trial_name      = "training-trial-1"
  }
  
  tensor_board_output_config = {
    s3_output_path = "s3://my-bucket/tensorboard/"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| training_job_name | The name of the training job | `string` | n/a | yes |
| role_arn | The IAM role ARN for the training job | `string` | n/a | yes |
| algorithm_specification | Specifies the training algorithm to be used | `object` | n/a | yes |
| input_data_config | Input data configuration for the training job | `list(object)` | n/a | yes |
| output_data_config | Output data configuration for the training job | `object` | n/a | yes |
| resource_config | Resource configuration for the training job | `object` | n/a | yes |
| stopping_condition | Stopping condition for the training job | `object` | n/a | yes |
| hyper_parameters | Hyperparameters for the training job | `map(string)` | `null` | no |
| checkpoint_config | Checkpoint configuration for the training job | `object` | `null` | no |
| debug_hook_config | Debug hook configuration for the training job | `object` | `null` | no |
| tensor_board_output_config | TensorBoard output configuration for the training job | `object` | `null` | no |
| experiment_config | Experiment configuration for the training job | `object` | `null` | no |
| tags | A map of tags to assign to the training job | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| training_job_name | The name of the training job |
| training_job_arn | The ARN of the training job |
| model_artifacts | The S3 path where model artifacts are stored |
| training_job_status | The status of the training job |
| secondary_status | The secondary status of the training job |
| creation_time | The time when the training job was created |
| training_end_time | The time when the training job ended |
| last_modified_time | The time when the training job was last modified |
| billable_time_in_seconds | The billable time in seconds for the training job |

## License

This module is open source and available under the MIT License.
