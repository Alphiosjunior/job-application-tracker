# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-lambda-role"
    Environment = var.environment
  }
}

# IAM Policy for Lambda to access DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "${var.project_name}-lambda-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.job_applications.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda Function - Create Application
resource "aws_lambda_function" "create_application" {
  filename         = "${path.module}/lambda_functions.zip"
  function_name    = "${var.project_name}-create-application"
  role            = aws_iam_role.lambda_role.arn
  handler         = "create_application.lambda_handler"
  runtime         = "python3.12"
  timeout         = 10
  source_code_hash = filebase64sha256("${path.module}/lambda_functions.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications.name
    }
  }

  tags = {
    Name        = "${var.project_name}-create-application"
    Environment = var.environment
  }
}

# Lambda Function - List Applications
resource "aws_lambda_function" "list_applications" {
  filename         = "${path.module}/lambda_functions.zip"
  function_name    = "${var.project_name}-list-applications"
  role            = aws_iam_role.lambda_role.arn
  handler         = "list_applications.lambda_handler"
  runtime         = "python3.12"
  timeout         = 10
  source_code_hash = filebase64sha256("${path.module}/lambda_functions.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications.name
    }
  }

  tags = {
    Name        = "${var.project_name}-list-applications"
    Environment = var.environment
  }
}

# Lambda Function - Get Application
resource "aws_lambda_function" "get_application" {
  filename         = "${path.module}/lambda_functions.zip"
  function_name    = "${var.project_name}-get-application"
  role            = aws_iam_role.lambda_role.arn
  handler         = "get_application.lambda_handler"
  runtime         = "python3.12"
  timeout         = 10
  source_code_hash = filebase64sha256("${path.module}/lambda_functions.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications.name
    }
  }

  tags = {
    Name        = "${var.project_name}-get-application"
    Environment = var.environment
  }
}

# Lambda Function - Update Application
resource "aws_lambda_function" "update_application" {
  filename         = "${path.module}/lambda_functions.zip"
  function_name    = "${var.project_name}-update-application"
  role            = aws_iam_role.lambda_role.arn
  handler         = "update_application.lambda_handler"
  runtime         = "python3.12"
  timeout         = 10
  source_code_hash = filebase64sha256("${path.module}/lambda_functions.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications.name
    }
  }

  tags = {
    Name        = "${var.project_name}-update-application"
    Environment = var.environment
  }
}

# Lambda Function - Delete Application
resource "aws_lambda_function" "delete_application" {
  filename         = "${path.module}/lambda_functions.zip"
  function_name    = "${var.project_name}-delete-application"
  role            = aws_iam_role.lambda_role.arn
  handler         = "delete_application.lambda_handler"
  runtime         = "python3.12"
  timeout         = 10
  source_code_hash = filebase64sha256("${path.module}/lambda_functions.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications.name
    }
  }

  tags = {
    Name        = "${var.project_name}-delete-application"
    Environment = var.environment
  }
}