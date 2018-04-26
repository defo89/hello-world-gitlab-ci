terraform {
  backend "s3" {
    bucket = "terraform-remote-state-defo"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}