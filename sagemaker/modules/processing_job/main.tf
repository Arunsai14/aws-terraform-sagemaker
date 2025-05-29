/**
 * # AWS SageMaker Processing Job Module
 *
 * This module creates a SageMaker processing job with configurable settings.
 */

resource "aws_sagemaker_processing_job" "this" {
  processing_job_name = var.processing_job_name
  role_arn            = var.role_arn
  
  processing_resources {
    cluster_config {
      instance_count    = var.processing_resources.cluster_config.instance_count
      instance_type     = var.processing_resources.cluster_config.instance_type
      volume_size_in_gb = var.processing_resources.cluster_config.volume_size_in_gb
      volume_kms_key_id = lookup(var.processing_resources.cluster_config, "volume_kms_key_id", null)
    }
  }
  
  app_specification {
    image_uri = var.app_specification.image_uri
    container_arguments = lookup(var.app_specification, "container_arguments", null)
    container_entrypoint = lookup(var.app_specification, "container_entrypoint", null)
  }
  
  dynamic "processing_inputs" {
    for_each = var.processing_inputs != null ? var.processing_inputs : []
    content {
      input_name = processing_inputs.value.input_name
      s3_input {
        s3_uri          = processing_inputs.value.s3_input.s3_uri
        local_path      = processing_inputs.value.s3_input.local_path
        s3_data_type    = lookup(processing_inputs.value.s3_input, "s3_data_type", "S3Prefix")
        s3_data_distribution_type = lookup(processing_inputs.value.s3_input, "s3_data_distribution_type", "FullyReplicated")
        s3_input_mode   = lookup(processing_inputs.value.s3_input, "s3_input_mode", "File")
        s3_compression_type = lookup(processing_inputs.value.s3_input, "s3_compression_type", "None")
      }
    }
  }
  
  dynamic "processing_output_config" {
    for_each = var.processing_output_config != null ? [var.processing_output_config] : []
    content {
      outputs {
        output_name = processing_output_config.value.outputs.output_name
        s3_output {
          s3_uri = processing_output_config.value.outputs.s3_output.s3_uri
          local_path = processing_output_config.value.outputs.s3_output.local_path
          s3_upload_mode = lookup(processing_output_config.value.outputs.s3_output, "s3_upload_mode", "EndOfJob")
        }
      }
      kms_key_id = lookup(processing_output_config.value, "kms_key_id", null)
    }
  }
  
  dynamic "network_config" {
    for_each = var.network_config != null ? [var.network_config] : []
    content {
      vpc_config {
        security_group_ids = network_config.value.vpc_config.security_group_ids
        subnets            = network_config.value.vpc_config.subnets
      }
      enable_inter_container_traffic_encryption = lookup(network_config.value, "enable_inter_container_traffic_encryption", null)
      enable_network_isolation = lookup(network_config.value, "enable_network_isolation", null)
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
  
  stopping_condition {
    max_runtime_in_seconds = var.stopping_condition.max_runtime_in_seconds
  }
  
  tags = var.tags
}
