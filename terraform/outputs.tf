output "api_gateway_url" {
  description = "API Gateway endpoint URL"
  value       = "${aws_api_gateway_deployment.job_tracker_deployment.invoke_url}/applications"
}

output "api_gateway_base_url" {
  description = "API Gateway base URL"
  value       = aws_api_gateway_deployment.job_tracker_deployment.invoke_url
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.job_applications.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.job_applications.arn
}

output "lambda_functions" {
  description = "Lambda function names"
  value = {
    create = aws_lambda_function.create_application.function_name
    list   = aws_lambda_function.list_applications.function_name
    get    = aws_lambda_function.get_application.function_name
    update = aws_lambda_function.update_application.function_name
    delete = aws_lambda_function.delete_application.function_name
  }
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}