resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-west-1a"
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-west-1b"
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "eu-west-1c"
}