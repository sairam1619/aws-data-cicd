resource "aws_lambda_function" "lambda" {
  function_name = "demo_lambda"
  role          = "arn:aws:iam::854359848205:role/athena_lambda_iam"
  handler       = "index.handler"
  runtime       = "python3.14"
  filename      = "lambda.zip"
  timeout       = 850
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
