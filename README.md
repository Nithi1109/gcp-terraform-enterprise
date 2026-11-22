# GCP Terraform Enterprise

## 1. Architecture
- Reusable Terraform modules under modules/ (network, compute, iam, storage)
- Environment roots under environments/dev and environments/prod
- HCP Terraform organization nithi-gcp-tf with gcp-dev and gcp-prod workspaces
- HashiCorp Vault KV v2 at secret/gcp-config
- GitHub Actions CI/CD with Terraform fmt/validate and Conftest/OPA policy checks

## 2. Prerequisites
- Terraform CLI and HashiCorp Vault CLI on PATH
- Conftest / OPA for local policy checks
- GCP project and credentials for target modules
- HCP Terraform organization nithi-gcp-tf with gcp-dev and gcp-prod workspaces
- Git access to Nithi1109/gcp-terraform-enterprise

## 3. Deployment Procedure
1. Start local Vault dev server in a separate window: vault server -dev -dev-root-token-id="dev-only-token"
2. Set VAULT_ADDR and VAULT_TOKEN, then write and verify secret/gcp-config with vault kv put and vault kv get
3. Initialize and validate the target environment: terraform -chdir=environments\dev init and terraform -chdir=environments\dev validate
4. Run plan and apply locally or trigger a run in HCP Terraform (gcp-dev or gcp-prod)

## 4. Variables
- Environment and Terraform variables for GCP project settings and module inputs across dev and prod
- Vault KV v2 secret/gcp-config keys: app_env_label (vault-managed-secret) and db_secret_name (gcp-app-secret)
- HCP Terraform workspace variables for remote execution, including reachable VAULT_ADDR and VAULT_TOKEN when needed

## 5. CI/CD Flow
- Pushing changes or opening pull requests on Nithi1109/gcp-terraform-enterprise triggers GitHub Actions
- Runs Terraform formatting and validation checks alongside Conftest / OPA policy checks

## 6. Troubleshooting
- Fix malformed VAULT_ADDR (remove extra URLs or Markdown link brackets/parentheses) and avoid leading > in PowerShell lines
- Keep data "vault_kv_secret_v2" when locals requires a non-ephemeral value despite Vault KV v2 deprecation warnings
- Treat LF to CRLF line-ending notices on Windows as normal and retry transient HCP Terraform gateway errors
- Ensure valid GCP credentials and a reachable Vault address when running locally or via remote runners
