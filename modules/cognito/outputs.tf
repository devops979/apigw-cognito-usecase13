output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "user_pool_endpoint" {
  value = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.this.id}"
}

#output "user_pool_endpoint" {
#  value = aws_cognito_user_pool.this.endpoint 
#}