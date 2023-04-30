# Wagonkered Website Terraform
Terraform for deploying the Wagonkered website to AWS

## Prerequisites
For work on this repo you will require
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [tflint](https://github.com/terraform-linters/tflint) 
- [tfsec](https://github.com/aquasecurity/tfsec) 
- Create a terraform.tfvars file and populate it with relevant key-value pairs to match the variables in the [variables.tf file](https://github.com/wagonkered/website-terraform/blob/main/variables.tf) 

## Initialising Terraform
Must be done both most other terraform commands are run
```bash
terraform init
```

## Format
```bash
terraform fmt
```

## Linting
```bash
terraform validate
```
and
```bash
tflint --init
tflint
```

## Check for security compliance
```bash
tfsec
```

## Test deploying resources
```bash
terraform plan
```

## Deploy resources
```bash
terraform apply
```
