variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "af-south-1"  # Cape Town, South Africa
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "job-tracker"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for job applications"
  type        = string
  default     = "JobApplications"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}