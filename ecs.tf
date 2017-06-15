provider "dockerimage" {}

resource "aws_ecr_repository" "hawordpress" {
  name = "ha-wordpress"
}

resource "dockerimage_local" "hawordpress" {
  dockerfile_path = "docker" # set the path to the directory w/ the Dockerfile
  registry = "${aws_ecr_repository.hawordpress.repository_url}" # the registry's hostname
}

resource "dockerimage_remote" "hawordpress" {
  registry = "${aws_ecr_repository.hawordpress.repository_url}" # the registry's hostname
  image_id = "${dockerimage_local.hawordpress.id}" # the image ID to push
}

resource "aws_ecs_task_definition" "hawordpress" {
  family                = "wordpress"
  container_definitions = "${file("task-definitions/wordpress.json")}"
}

resource "aws_ecs_cluster" "hawordpress" {
  name = "wordpress"
}

resource "aws_ecs_service" "hawordpress" {
  name            = "wordpress"
  cluster         = "${aws_ecs_cluster.hawordpress.id}"
  task_definition = "${aws_ecs_task_definition.hawordpress.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.hawordpress.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.hawordpress.arn}"
    container_name   = "wordpress"
    container_port   = 80
  }
}