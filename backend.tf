terraform {
  backend "s3" {
    region = "ap-south-1"
    profile = "boto_usr"
    bucket = "csvconverted123"
    key = "terraform/state"
  }
}