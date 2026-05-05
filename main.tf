resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "lock_table" {
  name         = "lock_table"
  billing_mode = "PAY_PER_REQUEST"

  # Primary Key
  hash_key  = "UserID"
  range_key = "OrderID"

  attribute {
    name = "UserID"
    type = "S"
  }

  attribute {
    name = "OrderID"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "S"
  }

  # Global Secondary Index (uses remaining attributes)
  global_secondary_index {
    name            = "EmailIndex"
    hash_key        = "Email"
    range_key       = "CreatedAt"
    projection_type = "ALL"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = "demo_lambda"
  role          = "arn:aws:iam::854359848205:role/athena_lambda_iam"
  handler       = "index.handler"
  runtime       = "python3.14"
  filename      = "lambda.zip"
  timeout       = 850
}
