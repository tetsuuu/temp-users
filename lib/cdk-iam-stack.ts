import { Construct, Stack, StackProps }  from '@aws-cdk/core';
import { Group, Policy, PolicyStatement, ManagedPolicy, User } from '@aws-cdk/aws-iam';

const admins = 'adminGroup';
const adminUsers = [
  't_kinoshita@uluru.jp',
  'k_oga@uluru.jp',
  'k_doue@uluru.jp',
  'k_yoshida@uluru.jp',
  ];

const developers = 'devGroup';
const devUsers = [
  't_yamamoto@uluru.jp',
  'y_chuang@uluru.jp',
];
// const today = new Date(); 
// const createDate = new Date(String(today.getMonth()) + String(today.getDate()));
// const tempPassword = "Changeme" + createDate
const targetAccount = "" //process.env.CDK_DEFAULT_ACCOUNT cdk.jsonから呼び出す

export class CdkIamStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    /*これと同じことがしたい
    resource "aws_iam_account_password_policy" "default" {
      minimum_password_length        = 8
      require_lowercase_characters   = true
      require_numbers                = true
      require_symbols                = false
      require_uppercase_characters   = true
      allow_users_to_change_password = true
    }
    
    const accountPasswordPolicy = new PolicyStatement({});
    accountPasswordPolicy.addAccountCondition(targetAccount);
    accountPasswordPolicy.toJSON();
    
    const accountPasswordPolicy = new AccountPrincipal({accountId: targetAccount});
    accountPasswordPolicy.addToPolicy(passwordPolicy);
    */

    const changePasswordPolicy = new PolicyStatement(
      {
        resources: ["*"],
        actions: [
          "iam:GetAccountPasswordPolicy"
        ],
      } &&
      {
        resources: ["arn:aws:iam::account-id-without-hyphens:user/${aws:username}"],
        actions: [
          "iam:ChangePassword",
        ],
      },
    )

    const iamPassRoleAccessPolicy = new PolicyStatement({
      resources: ["*"],
      actions: [
        "iam:Get*",
        "iam:List*",
        "iam:PassRole"
        ],
    });

    const adminPolicy = ManagedPolicy.fromAwsManagedPolicyName("arn:aws:iam::aws:policy/AdministratorAccess");
    const powerUserPolicy = ManagedPolicy.fromAwsManagedPolicyName("arn:aws:iam::aws:policy/PowerUserAccess");
    const devPolicy = new Policy(this, 'iamPassRoleAccess', { 
      policyName: "iamPassRoleAccess",
      statements: [iamPassRoleAccessPolicy],
    });
    const commonPolicy = new Policy(this, 'changePassword', { 
      policyName: "changePassword",
      statements: [changePasswordPolicy],
    });

    const adminGroup = new Group(this, admins, { groupName: admins });
    adminGroup.addManagedPolicy(adminPolicy);
    adminGroup.attachInlinePolicy(commonPolicy);

    const devGroup = new Group(this, developers, { groupName: developers });
    devGroup.addManagedPolicy(powerUserPolicy);
    devGroup.attachInlinePolicy(devPolicy);
    devGroup.attachInlinePolicy(commonPolicy);

    adminUsers.forEach((adminUser) => {
      const user = new User(this, adminUser, {
        userName: adminUser,
        groups: [adminGroup],
      });
    });

    devUsers.forEach((devUser) => {
      const user = new User(this, devUser, {
        userName: devUser,
        groups: [devGroup]
      });
    });
  }
}
