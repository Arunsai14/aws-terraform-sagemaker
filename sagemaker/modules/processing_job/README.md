# AWS SageMaker Processing Job Module

This Terraform module creates an AWS SageMaker Processing Job with configurable settings.

## Features

- Creates a SageMaker processing job with customizable configuration
- Supports custom Docker container images for processing tasks
- Configurable input and output data sources
- Customizable resource allocation (instance type, count, volume size)
- Network configuration with VPC support
- Experiment tracking integration

## Usage

```hcl
module "sagemaker_processing_job" {
  source = "path/to/modules/processing_job"

  processing_job_name = "example-processing-job"
  role_arn            = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
  
  processing_resources = {
    cluster_config = {
      instance_count    = 1
      instance_type     = "ml.m5.large"
      volume_size_in_gb = 30
    }
  }
  
  app_specification = {
    image_uri = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-processing-image:latest"
    container_arguments = ["--input-data", "/opt/ml/processing/input", "--output-data", "/opt/ml/processing/output"]
  }
  
  processing_inputs = [
    {
      input_name = "input-data"
      s3_input = {
        s3_uri     = "s3://my-bucket/input-data/"
        local_path = "/opt/ml/processing/input"
      }
    }
  ]
  
  processing_output_config = {
    outputs = {
      output_name = "processed-data"
      s3_output = {
        s3_uri     = "s3://my-bucket/processed-data/"
        local_path = "/opt/ml/processing/output"
      }
    }
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 3600
  }
  
  tags = {
    Environment = "dev"
    Project     = "data-processing"
  }
}
```

## Examples

### Basic Processing Job

```hcl
module "basic_processing_job" {
  source = "path/to/modules/processing_job"

  processing_job_name = "basic-processing-job"
  role_arn            = aws_iam_role.sagemaker_execution_role.arn
  
  processing_resources = {
    cluster_config = {
      instance_count    = 1
      instance_type     = "ml.m5.large"
      volume_size_in_gb = 30
    }
  }
  
  app_specification = {
    image_uri = "683313688378.dkr.ecr.us-west-2.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
    container_arguments = ["--input-data", "/opt/ml/processing/input", "--output-data", "/opt/ml/processing/output"]
  }
  
  processing_inputs = [
    {
      input_name = "input-data"
      s3_input = {
        s3_uri     = "s3://my-bucket/input-data/"
        local_path = "/opt/ml/processing/input"
      }
    }
  ]
  
  processing_output_config = {
    outputs = {
      output_name = "processed-data"
      s3_output = {
        s3_uri     = "s3://my-bucket/processed-data/"
        local_path = "/opt/ml/processing/output"
      }
    }
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 3600
  }
}
```

### Processing Job with VPC Configuration

```hcl
module "vpc_processing_job" {
  source = "path/to/modules/processing_job"

  processing_job_name = "vpc-processing-job"
  role_arn            = aws_iam_role.sagemaker_execution_role.arn
  
  processing_resources = {
    cluster_config = {
      instance_count    = 1
      instance_type     = "ml.m5.xlarge"
      volume_size_in_gb = 50
    }
  }
  
  app_specification = {
    image_uri = "683313688378.dkr.ecr.us-west-2.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
    container_arguments = ["--input-data", "/opt/ml/processing/input", "--output-data", "/opt/ml/processing/output"]
  }
  
  processing_inputs = [
    {
      input_name = "input-data"
      s3_input = {
        s3_uri     = "s3://my-bucket/input-data/"
        local_path = "/opt/ml/processing/input"
      }
    }
  ]
  
  processing_output_config = {
    outputs = {
      output_name = "processed-data"
      s3_output = {
        s3_uri     = "s3://my-bucket/processed-data/"
        local_path = "/opt/ml/processing/output"
      }
    }
  }
  
  network_config = {
    vpc_config = {
      security_group_ids = ["sg-12345678"]
      subnets            = ["subnet-12345678"]
    }
    enable_network_isolation = true
  }
  
  stopping_condition = {
    max_runtime_in_seconds = 3600
  }
  
  experiment_config = {
    experiment_name = "data-processing-experiment"
    trial_name      = "processing-trial-1"
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
| processing_job_name | The name of the processing job | `string` | n/a | yes |
| role_arn | The IAM role ARN for the processing job | `string` | n/a | yes |
| processing_resources | The resources, including the compute instances and storage volumes, to use for the processing job | `object` | n/a | yes |
| app_specification | Configures the processing job to run a specified Docker container image | `object` | n/a | yes |
| stopping_condition | Stopping condition for the processing job | `object` | n/a | yes |
| processing_inputs | List of inputs for the processing job | `list(object)` | `null` | no |
| processing_output_config | Output configuration for the processing job | `object` | `null` | no |
| network_config | Network configuration for the processing job | `object` | `null` | no |
| experiment_config | Experiment configuration for the processing job | `object` | `null` | no |
| tags | A map of tags to assign to the processing job | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| processing_job_name | The name of the processing job |
| processing_job_arn | The ARN of the processing job |
| creation_time | The time when the processing job was created |
| processing_end_time | The time when the processing job ended |
| last_modified_time | The time when the processing job was last modified |
| processing_job_status | The status of the processing job |
| failure_reason | The reason the processing job failed, if it failed |

## License

This module is open source and available under the MIT License.
