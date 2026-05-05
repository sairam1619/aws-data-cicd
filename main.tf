resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "lock_table" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  attribute {
    name = "Name"
    type = "S"
  }

}

resource "aws_lambda_function" "lambda" {
  function_name = "demo_lambda"
  role          = "arn:aws:iam::854359848205:role/athena_lambda_iam"
  handler       = "index.handler"
  runtime       = "python3.14"
  filename      = "lambda.zip"
  time_out = "15 Minutes"
}
