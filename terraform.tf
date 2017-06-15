terraform {
  backend "s3" {
    bucket = "infrastructure-state"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}