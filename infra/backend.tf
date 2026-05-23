terraform {
  backend "s3" {
    bucket         = "ravula-terraform-bucket"
    key            = "s2pb-app/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}