# Terraform Coding Conventions

When writing Terraform code in this repository, please adhere to the following conventions:

## File Structure
- **Split by Resource/Service**: Avoid a monolithic `main.tf`. Instead, split configurations into logical files based on the service or resource type.
  - Examples: `vpc.tf`, `iam.tf`, `ec2.tf`, `s3.tf`, `security_groups.tf`.
- **Standard Files**:
  - `versions.tf`: Define Terraform version and provider requirements.
  - `variables.tf`: Define all input variables.
  - `outputs.tf`: Define all output values.
  - `locals.tf`: Define local values for complex logic or shared constants.
  - `data.tf`: (Optional) Define data sources if they are numerous, otherwise keep them near the relevant resources.

## Naming Conventions
- **Resources & Variables**: Use `snake_case` for all resource names, variable names, and output names.
- **Resource Names**: Do not repeat the resource type in the name (e.g., use `aws_s3_bucket "logs"` instead of `aws_s3_bucket "logs_bucket"`), unless necessary for clarity.
- **Tags**: Ensure resources are tagged with at least a `Name` tag where supported.

## Variables & Outputs
- **Type Constraints**: Always specify the `type` for variables.
- **Descriptions**: Always provide a `description` for variables and outputs to explain their purpose.
- **Defaults**: Provide `default` values where sensible, but avoid defaults for required configuration (like project names or specific IDs).

## Formatting & Style
- **Indentation**: Follow standard `terraform fmt` style (2 spaces indentation).
- **Alignment**: Align equals signs `=` in blocks for better readability where appropriate.
- **Comments**: Use `#` for single-line comments.

## Security & Best Practices
- **Secrets**: Never commit secrets (access keys, passwords) to git. Use variables or secrets management.
- **Security Groups**: Be specific with `cidr_blocks`. Avoid `0.0.0.0/0` for ingress unless intended (e.g., public web server).
- **IAM**: Follow the principle of least privilege. Avoid attaching `AdministratorAccess` or broad wildcards `*` in policies.

## Versions
- **Pinning**: Pin the `required_version` for Terraform and `version` for providers in `versions.tf` to ensure reproducibility.
