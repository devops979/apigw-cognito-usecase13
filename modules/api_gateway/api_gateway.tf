# CloudWatch Logs Role for API Gateway (account-wide setting)
resource "aws_iam_role" "api_gateway_cloudwatch" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  name = "${var.api_name}-api-gw-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  role       = aws_iam_role.api_gateway_cloudwatch[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "this" {
  count = var.enable_cloudwatch_logging ? 1 : 0

  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch[0].arn
}


# API Gateway REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = "${var.name}-api"
  description = "Demo API secured with Cognito"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = var.tags
}

# Resource for your specific path
resource "aws_api_gateway_resource" "hello" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "hello"
}

# GET method for the resource
resource "aws_api_gateway_method" "get_hello" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.hello.id
  http_method   = "GET"
  authorization = var.authorization_type
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}


# Cognito User Pool for authorization
resource "aws_api_gateway_authorizer" "cognito" {
  name            = "${var.name}-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.this.id
  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [var.cognito_user_pool_arn]
}


# Lambda integration for the GET method
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.hello.id
  http_method             = aws_api_gateway_method.get_hello.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "this" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.id,
      aws_api_gateway_integration.lambda_integration.uri,
      aws_api_gateway_method.get_hello.authorization,
      aws_api_gateway_authorizer.cognito.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Deployment Stage
resource "aws_api_gateway_stage" "dev" {
  depends_on = [aws_api_gateway_account.this]

  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name
  # Access logging (optional)
  dynamic "access_log_settings" {
    for_each = var.access_log_destination_arn != null ? [1] : []
    content {
      destination_arn = var.access_log_destination_arn
      format          = var.access_log_format
    }
  }

  tags = var.tags
}


data "aws_region" "current" {}
