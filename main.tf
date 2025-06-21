data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_app/lambda_function.py"
  output_path = "${path.module}/lambda_app/lambda_function.zip"
}


module "lambda" {
  source      = "./modules/lambda"
  lambda_zip  = data.archive_file.lambda_zip.output_path
  lambda_name = var.lambda_function_name
}

module "cognito" {
  source       = "./modules/cognito"
  name         = "hello-auth"
  callback_url = module.api_gateway.api_gateway_invoke_url
  region       = var.region
}

module "api_gateway" {
  source                     = "./modules/api_gateway"
  name                       = "hello-api-gateway"
  access_log_format          = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\"}"
  lambda_function_name       = module.lambda.lambda_function_name
  lambda_arn                 = module.lambda.lambda_arn
  cognito_user_pool_arn = module.cognito.user_pool_arn
  cognito_client_id          = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_endpoint = module.cognito.user_pool_endpoint
}

