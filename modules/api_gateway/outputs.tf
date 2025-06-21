output "api_gateway_rest_api_id" {
  description = "The ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_gateway_rest_api_name" {
  description = "The name of the API Gateway"
  value       = aws_api_gateway_rest_api.this.name
}

output "api_gateway_stage_name" {
  description = "The name of the API Gateway deployment stage"
  value       = aws_api_gateway_stage.dev.stage_name
}

output "api_gateway_invoke_url" {
  description = "Invoke URL for the deployed API Gateway stage"
  value       = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}/hello"
}

output "api_gateway_authorizer_id" {
  description = "The ID of the Cognito authorizer"
  value       = aws_api_gateway_authorizer.cognito.id
}

output "api_gateway_deployment_id" {
  description = "The ID of the API Gateway deployment"
  value       = aws_api_gateway_deployment.this.id
}

output "cloudwatch_role_arn" {
  description = "CloudWatch IAM Role ARN for API Gateway (if enabled)"
  value       = var.enable_cloudwatch_logging ? aws_iam_role.api_gateway_cloudwatch[0].arn : null
}
