data "terraform_remote_state" "develop" {
  backend = "s3"

  config {
    bucket = "cameraman-develop"  // TODO
    key    = "iam_user/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_iam_policy_document" "admin_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        //"arn:aws:iam::${data.terraform_remote_state.develop.account_id}:root",
        "${data.terraform_remote_state.develop.module.admin_group.group_arn}",
      ]
    }
  }
}

data "aws_iam_policy_document" "developer_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        //"arn:aws:iam::${data.terraform_remote_state.develop.account_id}:root",
        "${data.terraform_remote_state.develop.module.dev_group.group_arn}",
      ]
    }
  }
}

resource "aws_iam_role" "admin_role" {
  name               = "adminSwitchRole"
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_administratoraccess_to_assume_role" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "developer_role" {
  name               = "developerSwitchRole"
  assume_role_policy = data.aws_iam_policy_document.developer_assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_poweraccess_to_assume_role" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "attach_iamreadonly_to_assume_role" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}
