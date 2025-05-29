/**
 * # AWS SageMaker Training Job Module
 *
 * This module creates a SageMaker training job with configurable settings.
 */

resource "aws_sagemaker_training_job" "this" {
  training_job_name = var.training_job_name
  role_arn          = var.role_arn
  
  algorithm_specification {
    training_image     = var.algorithm_specification.training_image
    training_input_mode = var.algorithm_specification.training_input_mode
    algorithm_name     = lookup(var.algorithm_specification, "algorithm_name", null)
  }
  
  dynamic "hyper_parameters" {
    for_each = var.hyper_parameters != null ? [var.hyper_parameters] : []
    content {
      # Hyper parameters as key-value pairs
      for_each = hyper_parameters.value
      content {
        key   = hyper_parameters.key
        value = hyper_parameters.value
      }
    }
  }
  
  # Input data configuration
  dynamic "input_data_config" {
    for_each = var.input_data_config
    content {
      channel_name = input_data_config.value.channel_name
      data_source {
        s3_data_source {
          s3_data_type = input_data_config.value.data_source.s3_data_source.s3_data_type
          s3_uri       = input_data_config.value.data_source.s3_data_source.s3_uri
          s3_data_distribution_type = lookup(input_data_config.value.data_source.s3_data_source, "s3_data_distribution_type", "FullyReplicated")
        }
      }
      content_type = lookup(input_data_config.value, "content_type", null)
      compression_type = lookup(input_data_config.value, "compression_type", null)
      input_mode = lookup(input_data_config.value, "input_mode", null)
    }
  }
  
  # Output data configuration
  output_data_config {
    s3_output_path = var.output_data_config.s3_output_path
    kms_key_id     = lookup(var.output_data_config, "kms_key_id", null)
  }
  
  resource_config {
    instance_type  = var.resource_config.instance_type
    instance_count = var.resource_config.instance_count
    volume_size_in_gb = var.resource_config.volume_size_in_gb
    volume_kms_key_id = lookup(var.resource_config, "volume_kms_key_id", null)
  }
  
  stopping_condition {
    max_runtime_in_seconds = var.stopping_condition.max_runtime_in_seconds
    max_wait_time_in_seconds = lookup(var.stopping_condition, "max_wait_time_in_seconds", null)
  }
  
  dynamic "checkpoint_config" {
    for_each = var.checkpoint_config != null ? [var.checkpoint_config] : []
    content {
      s3_uri = checkpoint_config.value.s3_uri
      local_path = lookup(checkpoint_config.value, "local_path", null)
    }
  }
  
  dynamic "debug_hook_config" {
    for_each = var.debug_hook_config != null ? [var.debug_hook_config] : []
    content {
      s3_output_path = debug_hook_config.value.s3_output_path
      collection_configurations {
        collection_name = debug_hook_config.value.collection_configurations.collection_name
        collection_parameters = lookup(debug_hook_config.value.collection_configurations, "collection_parameters", null)
      }
    }
  }
  
  dynamic "tensor_board_output_config" {
    for_each = var.tensor_board_output_config != null ? [var.tensor_board_output_config] : []
    content {
      s3_output_path = tensor_board_output_config.value.s3_output_path
    }
  }
  
  dynamic "experiment_config" {
    for_each = var.experiment_config != null ? [var.experiment_config] : []
    content {
      experiment_name = experiment_config.value.experiment_name
      trial_name = lookup(experiment_config.value, "trial_name", null)
      trial_component_display_name = lookup(experiment_config.value, "trial_component_display_name", null)
    }
  }
  
  tags = var.tags
}
