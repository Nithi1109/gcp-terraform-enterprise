# GCP Terraform Enterprise Case Study (`gcp-terraform-enterprise`)

An end-to-end Infrastructure-as-Code (IaC) reference implementation provisioning modular Google Cloud Platform (GCP) infrastructure using **HCP Terraform**, **HashiCorp Vault**, **Open Policy Agent (OPA / Conftest)**, and **GitHub Actions CI/CD**.

---

## Architecture Overview

```text
+-------------------+       +------------------------+       +-----------------------+
|  GitHub Repo      | ----> |  GitHub Actions CI/CD  | ----> |  HCP Terraform        |
|  (main / PRs)     |       |  - fmt & validate      |       |  (nithi-gcp-tf)       |
+-------------------+       |  - OPA / Conftest      |       |  - gcp-dev            |
                            |  - Remote Plan/Apply   |       |  - gcp-prod           |
                            +-----------+------------+       +-----------+-----------+
                                        |                                |
                                        v                                v
                            +------------------------+       +-----------------------+
                            |  HashiCorp Vault (KVv2)|       |  Google Cloud (GCP)   |
                            |  secret/gcp-config     |       |  - VPC & Subnets      |
                            |  (via ngrok HTTPS)     |       |  - Compute (dev-vm-1) |
                            +------------------------+       |  - IAM & Storage      |
                                                             +-----------------------+
```

### Key Components
* **Modular GCP Infrastructure (`modules/`)**: Reusable Terraform modules for `network`, `compute`, `iam`, and `storage`.
* **Environment Isolation (`environments/`)**: Separate root configurations for `dev` and `prod`, backed by HCP Terraform workspaces (`gcp-dev` and `gcp-prod` under organization `nithi-gcp-tf`).
* **Dynamic Secrets (`HashiCorp Vault`)**: Sensitive configuration values are stored in Vault KV v2 at `secret/gcp-config` and read at runtime by Terraform rather than hardcoded in `.tfvars` files.
* **Policy-as-Code (`policies/gcp.rego`)**: Enforces governance and security guardrails across `dev`, `prod`, and `modules` using Conftest before any plan or apply executes.
* **Automated CI/CD (`.github/workflows/terraform.yml`)**: Runs formatting, validation, and policy checks on every push and pull request, executes remote plans via HCP Terraform, and gates `terraform apply` behind manual `workflow_dispatch` approval.

---

## Repository Structure

```text
gcp-terraform-enterprise/
├── .github/workflows/terraform.yml   # CI/CD pipeline (Validate, OPA Policy, Plan & Apply)
├── environments/
│   ├── dev/                          # Development root module (HCP workspace: gcp-dev)
│   └── prod/                         # Production root module (HCP workspace: gcp-prod)
├── modules/
│   ├── compute/                      # Compute Engine VM instances & tags
│   ├── iam/                          # Service accounts & IAM role bindings
│   ├── network/                      # VPC network, subnets & firewall rules
│   └── storage/                      # Google Cloud Storage buckets
├── policies/gcp.rego                 # OPA/Conftest policy rules
└── README.md
```

---

## Local Setup & Execution

### 1. Start & Seed Local HashiCorp Vault
```powershell
# Terminal 1: Start Vault dev server
vault server -dev -dev-root-token-id="dev-only-token"

# Terminal 2: Set environment variables and write secrets
$env:VAULT_ADDR = "http://127.0.0.1:8200"
$env:VAULT_TOKEN = "dev-only-token"

vault kv put secret/gcp-config project_id="<YOUR_GCP_PROJECT_ID>" region="us-central1" zone="us-central1-a"
vault kv get secret/gcp-config
```

### 2. Run Policy Checks & Terraform Locally
```powershell
terraform fmt -check -recursive
conftest test --policy policies/gcp.rego environments/dev
conftest test --policy policies/gcp.rego environments/prod
conftest test --policy policies/gcp.rego modules

cd environments\dev
terraform init
terraform plan
```

---

## GitHub Actions CI/CD Setup

### Required Repository Secrets
| Secret Name | Purpose |
| :--- | :--- |
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | GCP Workload Identity Provider resource name for keyless OIDC auth |
| `GCP_SERVICE_ACCOUNT` | GCP Service Account email used by Terraform |
| `TF_API_TOKEN` | HCP Terraform user/team API token for remote backend access |
| `VAULT_ADDR` | Public HTTPS URL of the Vault server (e.g., `ngrok` forwarding URL) |
| `VAULT_TOKEN` | Token with read access to `secret/data/gcp-config` |

### Bridging Local Vault to GitHub Actions (`ngrok`)
```powershell
ngrok http 8200
```
Copy the generated `https://...` forwarding URL into the `VAULT_ADDR` GitHub secret (without a trailing slash), trigger the workflow, and stop `ngrok` (`Ctrl + C`) once testing completes.

---

## Validation: State Drift Detection & Remediation

1. **Baseline Provisioning**: Deployed the `dev` environment (`dev-vm-1`) through HCP Terraform (`gcp-dev`).
2. **Simulated Manual Drift**: Modified network tags directly on `dev-vm-1` outside of Terraform.
3. **Drift Detection**: Executed `terraform plan`—HCP Terraform detected the discrepancy between desired configuration and actual instance tags.
4. **Automated Remediation**: Applied the plan to restore `dev-vm-1` back to its declared state in Git.

---

## Troubleshooting Notes

* **PowerShell `PATH` Updates**: After installing CLI tools (`ngrok`, `vault`, `conftest`) via `winget`, open a fresh PowerShell session so updated `PATH` entries take effect.
* **Vault Connection in CI/CD**: Ensure both the local `vault server` process and `ngrok http 8200` tunnel are running before triggering GitHub Actions, and verify `VAULT_ADDR` has no trailing `/v1/...` path.
