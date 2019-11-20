# Users
##
module "t_kinoshita" {
  source = "../modules/iam_user"

  name = "t_kinoshita@uluru.jp"
}

module "k_oga" {
  source = "../modules/iam_user"

  name = "k_oga@uluru.jp"
}

module "k_doue" {
  source = "../modules/iam_user"

  name = "k_doue@uluru.jp"
}

module "t_yamamoto" {
  source = "../modules/iam_user"

  name = "t_yamamoto@uluru.jp"
}

module "k_yoshida" {
  source = "../modules/iam_user"

  name = "k_yoshida@uluru.jp"
}

module "y_chuang" {
  source = "../modules/iam_user"

  name = "y_chuang@uluru.jp"
}


# Admin group
resource "aws_iam_group_membership" "admin" {
  name = "admin"

  users = [
    module.t_kinoshita.name,
    module.k_doue.name,
    module.k_oga.name,
  ]

  group = module.admin_group.name
}

# Dev group
resource "aws_iam_group_membership" "dev" {
  name = "dev"

  users = [
    module.k_yoshida.name,
    module.t_yamamoto.name,
    module.y_chuang.name,
  ]

  group = module.dev_group.name
}

# Change password group
resource "aws_iam_group_membership" "change_passwd" {
  name = "change_password"

  users = [
    module.t_kinoshita.name,
    module.k_doue.name,
    module.k_oga.name,
    module.k_yoshida.name,
    module.t_yamamoto.name,
    module.y_chuang.name,
  ]

  group = module.change_pass_group.name
}
