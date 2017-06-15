terraform {
  backend "s3" {
    bucket = "ha-wordpress-infrastructure-state"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}