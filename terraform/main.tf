terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# DynamoDB Table for Job Applications
resource "aws_dynamodb_table" "job_applications" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"  # On-demand pricing (no need to provision capacity)
  hash_key       = "applicationId"     # Primary key

  attribute {
    name = "applicationId"
    type = "S"  # S = String
  }

  # Enable point-in-time recovery (optional, but good practice)
  point_in_time_recovery {
    enabled = false  # Set to true if you want backups
  }

  # Tags for organization
  tags = {
    Name        = "${var.project_name}-table"
    Environment = var.environment
    Project     = var.project_name
  }
}