# AWS RDS with IAM credentials

In addition to using
[user/password](../../setup/installation.md#connect-an-external-database) for
database authentication, Coder supports connecting to Amazon RDS databases
using IAM credentials.

## Requirements

- An EKS cluster with an [IAM OIDC provider enabled](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html)
- An RDS instance with [IAM authentication enabled](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Enabling.html)

## Setup

1. [Create an IAM role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html)
to use for database authentication.

1. Create an IAM policy for the role created in Step 1.

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
             "rds-db:connect"
         ],
         "Resource": [
             "arn:aws:rds-db:us-east-2:1234567890:dbuser:db-ABCDEFGHIJKL01234/db_user"
         ]
      }
   ]
}
```

1. Add a Trust Relationship to the IAM role.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Federated": "arn:aws:iam::111122223333:oidc-provider/oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "arn:aws:iam::111122223333:oidc-provider/oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub":"system:serviceaccount:<cluster>:<namespace>"
                }
            }
        }
    ]
}
```

1. Create a database user with the same name specified in the policy above, and
   grant them the `rds_iam` role.

```sql
CREATE USER dbuser WITH LOGIN; 
GRANT rds_iam TO dbuser;
```

1. Set the following values in your Helm chart and re-deploy Coder.

```yaml
coderd:
  builtinProviderServiceAccount:
    annotations:
      # this role is assumed by the coderd pods, it must have correct IAM policy to connect to RDS
      "eks.amazonaws.com/role-arn": "arn:aws:iam::1234567890:role/example"
postgres:
  host: "example.us-east-1.rds.amazonaws.com"
  port: "5432"
  user: "dbuser"
  database: "coder"
  # notice the password field is not used
  connector: "awsiamrds"
  default:
    enable: false
```

Documentation references:

- [IAM database authentication for MariaDB, MySQL, and PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html)

- [Creating a database account using IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.DBAccounts.html#UsingWithRDS.IAMDBAuth.DBAccounts.PostgreSQL)
