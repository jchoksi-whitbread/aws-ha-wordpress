resource "aws_iam_role" "hawordpress" {
    name = "ecs-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ecs.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hawordpress" {
    role       = "${aws_iam_role.hawordpress.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "hawordpress2" {
    name = "ecs-auto-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "application-autoscaling.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hawordpress2" {
    role       = "${aws_iam_role.hawordpress2.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}