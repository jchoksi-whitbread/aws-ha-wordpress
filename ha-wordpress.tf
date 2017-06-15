provider "aws" {
  region     = "${var.region}"
}

provider "dockerimage" {}

resource "aws_ecr_repository" "hawordpressrepository" {
  name = "aws-ha-wordpress-repo"
}

resource "dockerimage_local" "wordpressimage" {
  dockerfile_path = "docker" # set the path to the directory w/ the Dockerfile
  registry = "${aws_ecr_repository.hawordpressrepository.repository_url}" # the registry's hostname
}

resource "dockerimage_remote" "wordpressimage" {
  registry = "${aws_ecr_repository.hawordpressrepository.repository_url}" # the registry's hostname
  image_id = "${dockerimage_local.wordpressimage.id}" # the image ID to push
}