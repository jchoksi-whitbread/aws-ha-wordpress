provider "aws" {
  region     = "${var.region}"
}

provider "dockerimage" {}

resource "aws_ecr_repository" "hawordpressrepository" {
  name = "aws-ha-wordpress-repo"
}

resource "dockerimage_local" "wordpressimage" {
  dockerfile_path = "docker" # set the path to the directory w/ the Dockerfile
  tag = "terraform-provider-docker-image-wordpress:latest" # the tag for the image locally
}

resource "dockerimage_remote" "wordpressimage" {
  tag = "terraform-provider-docker-image-wordpress:latest" # the tag for the remote image
  registry = "${aws_ecr_repository.hawordpressrepository.repository_url}" # the registry's hostname
  image_id = "${dockerimage_local.wordpressimage.id}" # the image ID to push
}