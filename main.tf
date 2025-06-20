data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_app/main.py"
  output_path = "${path.module}/lambda_app/main.zip"
}


module "lambda" {
  source              = "./modules/lambda"
  lambda_zip     = data.archive_file.lambda_zip.output_path
  lambda_name         = var.lambda_function_name
}

module "cognito" {
  source       = "./modules/cognito"
  name         = "hello-auth"
  callback_url = module.api_gateway.api_endpoint
  region       = var.region
}

module "api_gateway" {
  source          = "./modules/api_gateway"
  lambda_function_name = module.lambda.lambda_function_name
  lambda_arn     = module.lambda.lambda_arn
  cognito_client_id        = module.cognito.client_id
  cognito_user_pool_endpoint = module.cognito.user_pool_endpoint
}

