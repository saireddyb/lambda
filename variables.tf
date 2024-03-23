# variables for aws resource creations
variable "aws_access_key" {
  type    = string
  sensitive = true
}

variable "aws_secret_key" {
  type    = string
  sensitive = true
}

# Variables for lambda function 5
variable "lambda5_function_name" {
  description = "The name of the Lambda function"
}

variable "lambda5_description" {
  description = "The description of the Lambda function"
}

variable "lambda5_handler" {
  description = "The entry point of the Lambda function"
}

variable "lambda5_runtime" {
  description = "The runtime environment for the Lambda function"
}

variable "lambda5_source_path" {
  description = "The path to the source code of the Lambda function"
}

variable "lambda5_tags" {
  description = "A map of tags to assign to the Lambda function"
}
