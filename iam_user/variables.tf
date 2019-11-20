data "aws_caller_identity" "self" {}

variable "account_id" {
  default = data.aws_caller_identity.self.account_id
}

variable "prod_id" {
  default = "PROD_ID"
}

variable "stg_id" {
  default = "STG_ID"
}
