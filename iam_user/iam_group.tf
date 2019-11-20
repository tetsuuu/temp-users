# Groups
## Admin Group
module "admin_group" {
  source = "../modules/iam_group"
  
  name        = "Admin"
  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

## Dev Group
module "dev_group" {
  source = "../modules/iam_group"

  name = "Dev"
  policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
    "arn:aws:iam::ACCOUNT_ID:policy/${module.iam_pass_role_access.policy_name}" //TODO
  ]
}

## Change Pass Group
module "change_pass_group" {
  source = "../modules/iam_group"

  name        = "Change_pass"
  policy_arns = ["arn:aws:iam::ACCOUNT_ID:policy/${module.change_password.policy_name}"] //TODO
}
