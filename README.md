## Customer Onboarding Folder Layout
Each customer folder under `/infra/` represents an isolated Terraform execution environment.

### Benefits:
- Per-customer state tracking
- Simple rollback and destroy
- Parallel provisioning possible

### Adding a New Customer:
1. Run ./variable_generator.sh and select mode 2 to create and configure a new customer.
OR
1. Copy `infra/customertemplate/` to `infra/customerX/`
2. Update `terraform.auto.tfvars` with customer-specific values
3. Update backend key to `customerX.tfstate`
4. Run `terraform init && terraform plan && terraform apply`

### Adding Sandbox Subscriptions
Sandbox subscriptions can be added dynamically by updating the `sandbox_sub_ids` list in `landingzone/terraform.auto.tfvars` and re-applying Terraform in the landingzone directory. The sandbox management group has limited HIPAA policies (e.g., audit-only/X).

### Customizing Naming Conventions
The project uses a standardized naming convention: `<resource_prefix>-<app>-<environment>-<location_short>-<instance_count>`. To modify this for your organization:

1. **Update locals Block**: In each module (e.g., `modules/compute/main.tf`), modify the `locals` block. For example, to use a prefix like `org-<app>-<env>`:
   ```hcl
   locals {
     vm_prefix = "org"
     app       = "linux"
     env       = var.environment
     loc       = var.location_short
     vm_name   = "${local.vm_prefix}-${local.app}-${local.env}-${local.loc}-${local.vm_instance}"
   }

