provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_region" "current" {
  current = true
}

providers {
  dockerimage = "/usr/local/bin/terraform-provider-docker-image"
}

resource "aws_ecr_repository" "hawordpressrepository" {
  name = "aws-ha-wordpress-repo"
}

resource "dockerimage_local" "wordpressimage" {
  dockerfile_path = "docker" # set the path to the directory w/ the Dockerfile
  tag = "terraform-provider-docker-image-wordpress:latest" # the tag for the image locally
}

resource "dockerimage_remote" "wordpressimage" {
  tag = "terraform-provider-docker-image-wordpress:latest" # the tag for the remote image
  registry = "${aws_ecr_repository.hawordpressrepository.registry_id}.dkr.${aws_region.current.endpoint}" # the registry's hostname
  image_id = "${dockerimage_local.wordpressimage.id}" # the image ID to push
}