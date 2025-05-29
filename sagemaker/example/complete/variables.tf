/**
 * # Variables for AWS SageMaker Complete Example
 */

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "sagemaker-complete-example"
  }
}

# VPC variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# Git repository variables
variable "git_repository_url" {
  description = "URL of the Git repository to use with SageMaker"
  type        = string
  default     = "https://github.com/example/repository.git"
}

variable "git_username" {
  description = "Username for Git repository authentication"
  type        = string
  default     = "git-user"
  sensitive   = true
}

variable "git_password" {
  description = "Password or token for Git repository authentication"
  type        = string
  default     = "git-password"
  sensitive   = true
}
