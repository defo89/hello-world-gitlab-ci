data "aws_ami" "webserver" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["webserver"]
  }

  most_recent = true
}