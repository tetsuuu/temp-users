data "aws_iam_policy_document" "change_passwod" {
  statement {
    effect = "Allow"

    actions = [
      "iam:GetAccountPasswordPolicy",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:ChangePassword",
    ]

    resources = ["arn:aws:iam::account-id-without-hyphens:user/$${aws:username}"]
  }
}

data "aws_iam_policy_document" "switch_admin" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
    // TODO
    resources = [
      "arn:aws:iam::PROD_ID:role/adminSwitchRole",
      "arn:aws:iam::STG_ID:role/adminSwitchRole",
    ]
  }
}

data "aws_iam_policy_document" "switch_developer" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
    // TODO
    resources = [
      "arn:aws:iam::PROD_ID:role/developerSwitchRole",
      "arn:aws:iam::STG_ID:role/developerSwitchRole",
    ]
  }
}

data "aws_iam_policy_document" "iam_pass_role_access" {
  statement {
    effect = "Allow"

    actions = [
      "iam:Get*",
      "iam:List*",
      "iam:PassRole"
    ]

    resources = ["*"]
  }
}

module "change_password" {
  source = "../modules/iam_policy"

  name        = "change_password"
  description = "for change user password"

  policy = data.aws_iam_policy_document.change_passwod.json
}

module "iam_pass_role_access" {
  source = "../modules/iam_policy"

  name        = "iam_pass_role_access"
  description = "for attach Iam Role"

  policy = data.aws_iam_policy_document.iam_pass_role_access.json
}

module "switch_admin" {
  source = "../modules/iam_policy"

  name        = "adminSwitchPolicy"
  description = "for swich staging and production by admin user"

  policy = data.aws_iam_policy_document.switch_admin.json
}

module "switch_developer" {
  source = "../modules/iam_policy"

  name        = "developerSwitchPolicy"
  description = "for swich staging and production by power user"

  policy = data.aws_iam_policy_document.switch_developer.json
}
