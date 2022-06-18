terraform {
  backend "s3" {
    bucket = "my-cops-state"
    key    = "terraform/backend"
    region = "ap-south-1"
  }
}