terraform {
  backend "s3" {
    bucket         = "sairam-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
