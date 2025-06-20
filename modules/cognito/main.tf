resource "aws_cognito_user_pool" "this" {
  name = var.name
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.name}-client"
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = false
  callback_urls = [var.callback_url]
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers = ["COGNITO"]
  
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "demo-auth-domain-${random_string.suffix.result}"
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  number  = true
  special = false
}

