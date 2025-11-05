# AWS Audit Preparation

## Creating a Cross-Account Role for Audit with Terraform

1. Initialize Terraform:

    ```bash
    terraform init
    ```

2. Apply the Terraform configuration to create the cross-account role:

    ```bash
    terraform apply # Answer 'yes' when prompted
    ```

3. Supply Blue Mountain Cyber with the generated Role ARN found in the Terraform output.

## Destroying the Cross-Account Role

When audit is complete, remove the cross-account role and associated resources:

```bash
terraform destroy # Answer 'yes' when prompted
```
