# GitHub Actions
## Intrduction
This folder contains GitHub Actions to automate following things.
1. Install helm chart on EKS cluster provisioned by Terraform to host java web application.
2. A manual trigger to uninstall helm chart.

There are two workflows, First one is installing helm chart. Which will be triggered automatically on push event to main branch. In which it will,
- **Build java web app**
- **Build and push docker image to ECR**
- **Install helm chart**

![deploy workflow png](https://raw.githubusercontent.com/iam-jawad/app-with-helm/main/.github/install-workflow.png)

Second workflow is for uninstalling helm chart. It can be triggered manually. In which it will,

- **Uninstall helm chart**

![deploy workflow png](https://raw.githubusercontent.com/iam-jawad/app-with-helm/main/.github/uninstall-workflow.png)

## Pre-Requisite
You will have to setup follwoing things to run this workflows.
1. Setup ECR in your AWS account on which you will be running these workflows. ECR will be used by app build workflow to push docker image and pods in EKS will pull image from there.
2. If you have provisioned infrastructure on AWS using github actions in my [this repo](https://github.com/iam-jawad/iac-with-terraform) so you will already have a OIDC and role setup. You just need to extend that role and add this repo as well like following.
    ```sh
    "Condition": {
        "StringLike": {
            "token.actions.githubusercontent.com:sub": [
            "repo:<github username>/iac-with-terraform:ref:refs/heads/<branch>"
            "repo:<github username>/app-with-helm:ref:refs/heads/<branch>"
            ]
        }
    }
    ```
    If you haven't provisioned infrastructure on AWS using my github actions guide so, go ahead and follow step 3 and 4 as well.
2. Create OIDC to connect AWS with GitHub. Do following steps to create OIDC provider in your AWS account.
    1. Go to **IAM** dashboard and form left pane select **Identity Providers**.
    2. On top right corner of page click on **Add Provider**.
    3. Now select **OpenID Connect**.
    4. In **Provider URL** add this ```https://token.actions.githubusercontent.com```.
    5. In **Audience** add this ```sts.amazonaws.com``` and click on **Add Provider**.
3. Create **IAM Role** and assign necessary permissions to it. This will be used by GitHub Actions to perform deployments on your AWS account. Use following steps to create IAM Role. (Please make sure your role have access for performing deployments on EKS cluster otherwise workflow will fail on helm chart installation)
    1. Go to **IAM** dashboard and from left pane select **Roles**.
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
                            "token.actions.githubusercontent.com:sub": "repo:<github username>/<repo     name>:ref:refs/heads/<branch>"
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
5. Now Configure following secrets in your GitHub account. To see how to configure secrets, you can have a look on [this link](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions).
    1. AWS_ROLE (add the arn of your AWS Role in secret which you have created above).
    2. ECR_URI (add just url of your ECR repo without repo name in secret. It will looks like this <account id>.dkr.ecr.us-east-1.amazonaws.com)
6. Now configure following Variables in your GitHub account. To see how to configure secrets, you can have a look on [this link](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/variables).
    1. AWS_REGION (add AWS account region in value on which operations will be perform e.g "us-east-1").
    2. CLUSTER_NAME (add any name in value which you want to assign to your EKS cluster e.g "demo-cluster")
    3. ECR_REPO (add ECR repo name in value which you have created to store docker image)
    4. HELM_REVISION_NAME (add any name in value which will be used by helm as a revisioning name e.g "test-deployment")

## Run it
### Install
Once all above Pre-Requisite steps are done you will be ready to give it a run.\
For that, push any small change in to main branch and deployment workflow will be triggered. Once that will complete successfully helm chart will be deployed on your EKS Cluster. To access java web app page you can locate an Application LoadBalancer in your AWS account, greb its DNS and access it in browser you should be able to see follwoing message.\
**Hi, This is Jawad's DevOps assessment.**
### uninstall
To uninstall helm chart trigger workflow manually with value "uninstall" and a second workflow to uninstall helm chart will be triggered.