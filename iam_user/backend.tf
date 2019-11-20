terraform {
  required_version = "= 0.12.6"

  backend "s3" {
    bucket = "" //TODO
    key    = "iam_user/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
