resource "aws_cognito_user_pool" "this" {
  name = var.name

  # Enable email-based sign-in
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Optional: add policies or schema for password, MFA, etc.
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "${var.name}-client"
  user_pool_id                         = aws_cognito_user_pool.this.id
  generate_secret                      = false
  callback_urls                        = [var.callback_url]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]

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
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Create a test user with temporary password
resource "aws_cognito_user" "demo_user" {
  user_pool_id         = aws_cognito_user_pool.this.id
  username             = var.user_email
  temporary_password   = var.temporary_password
  force_alias_creation = false

  attributes = {
    email          = var.user_email
    email_verified = "true"
  }

  # Remove message_action to allow Cognito to send the invitation email with the temporary password

  lifecycle {
    ignore_changes = [attributes["email_verified"]] # sometimes useful
  }
}
