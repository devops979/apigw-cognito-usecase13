variable "lambda_arn" {
  description = "ARN of the Lambda function to integrate with API Gateway"
  type        = string
  default     = "arn:aws:lambda:us-east-1:123456789012:function:demo-lambda"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "demo-lambda"
}

variable "cognito_client_id" {
  description = "Cognito App Client ID for authorization"
  type        = string
  default     = "dummy-client-id"
}

variable "cognito_user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  type        = string
  default     = "cognito-idp.us-east-1.amazonaws.com/us-east-1_Abc123456"
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  type        = string
  default     = "arn:aws:cognito-idp:us-east-1:123456789012:userpool/us-east-1_Abc123456"
}

variable "name" {
  description = "Base name for resources like API Gateway and authorizers"
  type        = string
  default     = "hello-api"
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "DemoAPI"
}

variable "enable_cloudwatch_logging" {
  description = "Enable CloudWatch logging for API Gateway"
  type        = bool
  default     = true
}

variable "authorization_type" {
  description = "Type of authorization for API Gateway method (e.g., NONE, COGNITO_USER_POOLS)"
  type        = string
  default     = "COGNITO_USER_POOLS"
}

variable "stage_name" {
  description = "Deployment stage name for the API"
  type        = string
  default     = "dev"
}

variable "access_log_destination_arn" {
  description = "CloudWatch Logs destination ARN for access logs"
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "Access log format for API Gateway"
  type        = string
  default     = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"user\":\"$context.authorizer.claims.sub\"}"
}

variable "tags" {
  description = "Tags to assign to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "HelloAPI"
  }
}

variable "region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "us-east-1"
}
