## Gitlab CI demo with Terraform and Packer

This setup leverages Gitlab CI to pre-bake AMIs and spin up a simple AWS setup using Terraform.

[Gitlab CI](https://about.gitlab.com/features/gitlab-ci-cd/) is used together with [GitLab Runner run in a container](https://docs.gitlab.com/runner/install/docker.html).
GitLab Runner should already be [registered](https://docs.gitlab.com/runner/register/index.html#docker).

You need to pass your [AWS credentials](https://docs.gitlab.com/ee/ci/variables/#secret-variables) to the runner:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

Also S3 bucket needs to be created for Terraform state and plan files (no public access).

**Operations workflow**

Gitlab CI job is triggered by committing to the repository.
If merged or commited to master, it will also run **terraform apply**


Each job will trigger the Gitlab runner to launch a Docker container with a specified image.

before_script
- verify Packer and Terraform versions and run **terraform init**

validate stage:
- run validation of Packer and Terraform configuration

build-ami stage:
- pre-bake AWS AMI with desired configuration using Ansible as provisioner

plan stage:
- run **terraform plan** and copy the plan file to an S3 bucket

deploy stage:
- copy the plan file back from an S3 bucket locally and run  **terraform apply**