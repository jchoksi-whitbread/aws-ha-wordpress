terraform {
  backend "s3" {
    bucket = "infrastructure-state"
    key    = "terraform.tfstate"
    region = "${var.region}"
  }
}