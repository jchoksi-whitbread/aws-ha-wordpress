resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow web inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}