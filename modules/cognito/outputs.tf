output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.this.arn
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "cognito_user_pool_domain" {
  value = aws_cognito_user_pool_domain.this.domain
}

output "cognito_login_url" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.region}.amazoncognito.com/login?response_type=code&client_id=${aws_cognito_user_pool_client.client.id}&redirect_uri=${var.callback_url}"
}


output "user_pool_endpoint" {
  value = aws_cognito_user_pool.this.endpoint
}