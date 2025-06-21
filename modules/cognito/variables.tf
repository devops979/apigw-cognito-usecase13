variable "name" {
  description = "Name to be used on cognito user pool"
  type        = string
}
variable "callback_url" {
  description = "Callback URL for Cognito user pool"
  type        = string
  default     = "https://example.com/callback"
}
variable "region" {
  description = "AWS region for the Cognito User Pool"
  type        = string
  default     = "us-east-1"
}
variable "user_email" {
  description = "Email address of the user to be created in the Cognito User Pool"
  type        = string
  default     = "anilkumar.padarthi@hcltech.com"
}
variable "temporary_password" {
  description = "Temporary password for the user in the Cognito User Pool"
  type        = string
  default     = "TemporaryPassword123!"
}
