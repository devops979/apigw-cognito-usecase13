output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}


output "api_endpoint" {
  value = module.api_gateway.api_gateway_invoke_url
}