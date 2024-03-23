# Lambda function with publically available lambda module
module "lambda1" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "lambda1"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "./lambdas/lambda1/src"

  tags = {
    Name = "lambda1"
  }
}

# Lambda function creation by making source code zip
module "lambda2" {
  source = "./modules/lambda"

  function_name = "lambda2"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "./lambdas/lambda2/src"

  tags = {
    Name = "lambda2"
  }
}

# Lambda creaton with installing packages when requirements.txt file is present.
module "lambda3" {
  source        = "./modules/lambda"
  function_name = "lambda3"
  description   = "My awesome lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  source_path = "./lambdas/lambda3/src"

  tags = {
    Name = "lambda3"
  }
  environment_variables = {
    saireddy = "value"
  }
}

# Lambda creation with source code from s3
module "lambda4" {
  source        = "./modules/lambda"
  function_name = "lambda4"
  description   = "My awesome lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  create_package = false

  s3_existing_package = {
    bucket = "lambda-s3-saireddy"
    key    = "lambda_test.zip"
  }

  tags = {
    Name = "lambda4"
  }

}

# Lambda function variablized
module "lambda5" {
  source = "./modules/lambda"

  function_name = var.lambda5_function_name
  description   = var.lambda5_description
  handler       = var.lambda5_handler
  runtime       = var.lambda5_runtime
  source_path   = var.lambda5_source_path

  tags = var.lambda5_tags
}








# terraform apply --auto-approve -var-file=variables.tfvars