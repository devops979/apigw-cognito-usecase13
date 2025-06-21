output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.this.arn
}