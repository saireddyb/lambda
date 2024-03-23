terraform {
  backend "s3" {
    bucket         = "saireddy12-iac"
    key            = "lambdas/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "lambdas-terraform.tfstate"
  }
}

