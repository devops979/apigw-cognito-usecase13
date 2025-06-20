variable "lambda_arn" {
  description = "Name to be used on lambda arn"
  type        = string
}

variable "lambda_function_name" {
    description = "Name to be used on lambda name"
    type = string
}

variable "cognito_client_id" {
}

variable "cognito_user_pool_endpoint" {
}

variable "name" {
  description = "Name to be used on api in apigateway"
  type        = string
}