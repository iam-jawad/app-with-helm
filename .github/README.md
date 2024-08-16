# GitHub Actions
## Intrduction
This folder contains GitHub Actions to automate EKS Cluster deployment using Terraform code.

There are two workflows, First one is for provisioning infrastructure. Which will be triggered automatically on push event to main branch. In which it will,
- **Test and plan Terraform code**
- **Apply Terraform code**

![deploy workflow png](https://raw.githubusercontent.com/iam-jawad/iac-with-terraform/main/.github/deploy-workflow.png)

Second workflow is for destroying whole provisioned infrastructure. It can be triggered manually. In which it will,

- **Test and plan Terraform code**
- **Perform Terraform destroy**

![deploy workflow png](https://raw.githubusercontent.com/iam-jawad/iac-with-terraform/main/.github/destroy-workflow.png)

## Pre-Requisite
You will have to setup follwoing things to run this workflows.
1. Setup S3 bucket which will be used by Terraform backend to store state file. You will need S3 bucket's **name, key name and region**, later to configure GitHub action's variables.
2. Create OIDC to connect AWS with GitHub. Do following steps to create OIDC provider in your AWS account.
    1. Go to **IAM** dashboard and form left pane select **Identity Providers**.
    2. On top right corner of page click on **Add Provider**.
    3. Now select **OpenID Connect**.
    4. In **Provider URL** add this ```https://token.actions.githubusercontent.com```.
    5. In **Audience** add this ```sts.amazonaws.com``` and click on **Add Provider**.
3. Create **IAM Role** and assign necessary permissions to it. This will be used by GitHub Actions to perform deployments on your AWS account. Use following steps to create IAM Role.
    1. Go to **IAM** dashboard and form left pane select **Roles**.
    2. On top right corner of page click on **Create Role**.
    3. Then select **Custom trust policy** and add follwoing policy. Replace place holders with your own accounts information.
    4. ```sh
        {
            "Version": "2008-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::<aws account id>:oidc-provider/token.actions.githubusercontent.com"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringLike": {
                            "token.actions.githubusercontent.com:sub": "repo:<github username>/<repo name>:ref:refs/heads/<branch>"
                        }
                    }
                },
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::<aws account id>:user/<aws account username>"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
        ```
    5. Click Next and on next window select all policies which are needed by your GitHub action workflow to perform operations on your AWS account. (For demo purpose you can select AdministratorAccess but in production this is not recommended)
    6. Then click next and give name to your role and create role. After creating role navigate to it and save it's ARN because it will be needed in GitHub Action's secrets.
4. Now Configure following secrets in your GitHub account. To see how to configure secrets, you can have a look on [this link](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions).
    1. AWS_ROLE (add the arn of your AWS Role in secret which you have created above).
    2. TF_VARS (add variables in secret like following which you want to override for default values. If you don't want to override any value so skip this.)
        ```sh
        var1=xyz
        var2=abc
        var3=123
        ```
5. Now configure following Variables in your GitHub account. To see how to configure secrets, you can have a look on [this link](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/variables).
    1. AWS_BUCKET_NAME (add your S3 bucket name in value which you have created to store Terraform state file).
    2. AWS_BUCKET_KEY_NAME (add key name in value which you have created in your S3 bucket to store Terraform state file).
    3. AWS_REGION (add AWS account region in value on which operations will be perform e.g "us-east-1").
    4. CLUSTER_NAME (add any name in value which you want to assign to your EKS cluster e.g "demo-cluster")

## Run it
### Deploy
Once all above Pre-Requisite steps are done you will be ready to give it a run.\
For that, push any small change in to main branch and deployment workflow will be triggered. Once that will complete successfully infrastructure will be provisioned on your AWS account. Which will contain following resources.

1) VPC
2) Four Subnets (two public and two private).
3) A Nat Gateway (this will be attached in one of the public subnets to provide secure internet conectivity to pods deployed in private subnets).
4) A Internet Gateway.
5) Two Route Tables (one with rule to route traffic from private subnets to nat gateway and other with rule to route traffic between public subnets and internet gateway).
6) EKS Cluster using Fargate (all required IAM policies and roles also will be created).
7) A OIDC Provider for EKS cluster conectivity with other AWS resources.
8) Two Fargate Profiles (one for kube-system namespace and other for custom namespace in which you can deploy application using helm code available in this repo. To improve security both profiles will be attached with private subnets so that pods can be deployed only in private subnets.).
9) Install Metrics Server so that HPA can be implemented on cluster.
10) Install AWS LoadBalancer Controller for handling ingress resources (all required IAM policies, roles and service account also will be created).
### Destroy
To destroy whole infrastructure trigger workflow manually with value "destroy" and a second workflow to destroy infrastructure will be triggered. After it will be completed successfully your AWS account will be cleaned.