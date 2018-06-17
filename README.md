## Gitlab CI demo with Terraform and Packer

This project provisions an AWS Application Load Balancer including the required infrastructure.
It was created mainly for learning purposes and consists of the following building blocks:
- EC2 instance AMI is pre-baked with [Packer](https://www.packer.io) using [Ansible](https://ansible.com) as a provisioner.
- Infrastructure is provisioned using [Terraform](https://www.terraform.io) module.
- Gitlab CI orchestrates actions with Packer and Terraform.

![AWS infra](img/infra.png)

## Terraform state
Terraform state and plan files are stored on S3 bucket, so it needs to be created beforehand.
No public access is required.

```
# state.tf
terraform {
  backend "s3" {
    bucket = "terraform-remote-state-defo"
    key    = "terraform-state-packer-aws-with-gitlab.tfstate"
    region = "eu-west-1"
  }
}
```

# Manual way

**Set desired AWS credentials**

In this example I am using [**aws-vault**](https://github.com/99designs/aws-vault) to work with desired profile.

```
❯ aws-vault add home
Enter Access Key ID: your-aws-access-key-id
Enter Secret Access Key: your-aws-access-key
Added credentials to profile "home" in vault

# launches subshell with desired AWS environment variables
❯ aws-vault exec -- home
```

**Requirements**
- [Packer](https://www.packer.io)
- [Terraform](https://www.terraform.io)
- [aws-vault](https://github.com/99designs/aws-vault)


```
❯ git clone git@github.com:dmitrijsf/hello-world-gitlab-ci.git
❯ cd hello-world-gitlab-ci

# build AWS AMI using Packer
❯ cd packer && packer validate template_ami.json
❯ packer build template_ami.json

# build AWS infrastructure using Terraform
❯ cd ../terraform
❯ terraform validate -var-file=aws-demo.tfvars
❯ terraform apply -var-file=aws-demo.tfvars
-- snip --
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

ALB DNS Name = default-1781065290.eu-west-1.elb.amazonaws.com
Bastion DNS Name = ec2-34-247-176-235.eu-west-1.compute.amazonaws.com
```


# Using Gitlab CI

## Configuration

[Gitlab CI](https://about.gitlab.com/features/gitlab-ci-cd/) is used together with [GitLab Runner run in a container](https://docs.gitlab.com/runner/install/docker.html).
GitLab Runner should already be [registered](https://docs.gitlab.com/runner/register/index.html#docker).

You need to pass your [AWS credentials](https://docs.gitlab.com/ee/ci/variables/#secret-variables) to the runner:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

All CI actions are defined in the [.gitlab-ci.yml](.gitlab-ci.yml) file.

**Docker container for CI**

Each job will trigger the Gitlab runner to launch a [Docker container](https://hub.docker.com/r/dmitrijsf/ci-docker/) to execute commands as instructed in the **gitlab-ci.yml** file.

```
image:
  name: dmitrijsf/ci-docker:latest
  entrypoint:
    - '/usr/bin/env'
    - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
```

**Operations workflow**

Gitlab CI Pipeline is triggered by committing to the repository.
If merged or commited to master, **terraform apply** and **packer build** options are available to run manually.

Edit the variable for S3 bucket (S3_BUCKET) accordingly.

```
variables:
  PACKER_DIR: packer
  TF_DIR: terraform
  PLAN: plan.tfplan
  S3_BUCKET: terraform-remote-state-defo
```

- before_script: verify Packer and Terraform versions and run **terraform init**

- validate stage: run validation of Packer and Terraform configuration

- build-ami stage: pre-bake AWS AMI with desired configuration using Ansible as provisioner

- plan stage: run **terraform plan** and copy the plan file to an S3 bucket

- deploy stage: copy the plan file back from an S3 bucket locally and run  **terraform apply**