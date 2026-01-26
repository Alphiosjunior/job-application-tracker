# API Gateway REST API
resource "aws_api_gateway_rest_api" "job_tracker_api" {
  name        = "${var.project_name}-api"
  description = "Job Application Tracker API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name        = "${var.project_name}-api"
    Environment = var.environment
  }
}

# /applications resource
resource "aws_api_gateway_resource" "applications" {
  rest_api_id = aws_api_gateway_rest_api.job_tracker_api.id
  parent_id   = aws_api_gateway_rest_api.job_tracker_api.root_resource_id
  path_part   = "applications"
}

# /applications/{id} resource
resource "aws_api_gateway_resource" "application_id" {
  rest_api_id = aws_api_gateway_rest_api.job_tracker_api.id
  parent_id   = aws_api_gateway_resource.applications.id
  path_part   = "{id}"
}

# POST /applications - Create
resource "aws_api_gateway_method" "create_application" {
  rest_api_id   = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id   = aws_api_gateway_resource.applications.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_application" {
  rest_api_id             = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id             = aws_api_gateway_resource.applications.id
  http_method             = aws_api_gateway_method.create_application.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_application.invoke_arn
}

# GET /applications - List All
resource "aws_api_gateway_method" "list_applications" {
  rest_api_id   = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id   = aws_api_gateway_resource.applications.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "list_applications" {
  rest_api_id             = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id             = aws_api_gateway_resource.applications.id
  http_method             = aws_api_gateway_method.list_applications.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.list_applications.invoke_arn
}

# GET /applications/{id} - Get One
resource "aws_api_gateway_method" "get_application" {
  rest_api_id   = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id   = aws_api_gateway_resource.application_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_application" {
  rest_api_id             = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id             = aws_api_gateway_resource.application_id.id
  http_method             = aws_api_gateway_method.get_application.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_application.invoke_arn
}

# PUT /applications/{id} - Update
resource "aws_api_gateway_method" "update_application" {
  rest_api_id   = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id   = aws_api_gateway_resource.application_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "update_application" {
  rest_api_id             = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id             = aws_api_gateway_resource.application_id.id
  http_method             = aws_api_gateway_method.update_application.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.update_application.invoke_arn
}

# DELETE /applications/{id} - Delete
resource "aws_api_gateway_method" "delete_application" {
  rest_api_id   = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id   = aws_api_gateway_resource.application_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_application" {
  rest_api_id             = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id             = aws_api_gateway_resource.application_id.id
  http_method             = aws_api_gateway_method.delete_application.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.delete_application.invoke_arn
}

# Lambda Permissions for API Gateway
resource "aws_lambda_permission" "create_application" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.job_tracker_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "list_applications" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_applications.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.job_tracker_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_application" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.job_tracker_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "update_application" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.job_tracker_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_application" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_application.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.job_tracker_api.execution_arn}/*/*"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "job_tracker_deployment" {
  depends_on = [
    aws_api_gateway_integration.create_application,
    aws_api_gateway_integration.list_applications,
    aws_api_gateway_integration.get_application,
    aws_api_gateway_integration.update_application,
    aws_api_gateway_integration.delete_application
  ]

  rest_api_id = aws_api_gateway_rest_api.job_tracker_api.id
  stage_name  = var.environment
}

# Enable CORS for /applications
resource "aws_api_gateway_method" "options_applications" {
  rest_api_id   = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id   = aws_api_gateway_resource.applications.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_applications" {
  rest_api_id = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id = aws_api_gateway_resource.applications.id
  http_method = aws_api_gateway_method.options_applications.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_applications" {
  rest_api_id = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id = aws_api_gateway_resource.applications.id
  http_method = aws_api_gateway_method.options_applications.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_applications" {
  rest_api_id = aws_api_gateway_rest_api.job_tracker_api.id
  resource_id = aws_api_gateway_resource.applications.id
  http_method = aws_api_gateway_method.options_applications.http_method
  status_code = aws_api_gateway_method_response.options_applications.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}