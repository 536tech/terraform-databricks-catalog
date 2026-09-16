# Databricks catalog Terraform module

One Unity Catalog catalog.

Creates one Unity Catalog catalog and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_catalog.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The resource addresses above are part of the DataTF import contract. Do not rename them.

## Usage

```hcl
module "catalog" {
  source  = "536tech/catalog/databricks"
  version = "1.0.1"

  name           = "sales"
  isolation_mode = "ISOLATED"
  owner          = "data-platform"
  comment        = "Sales domain"
  storage_root   = "abfss://sales@lake.dfs.core.windows.net/"

  grants = [{
    principal  = "data-engineers"
    privileges = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA"]
  }]
}
```

## Compatibility

Configure the Databricks provider in the calling root with a workspace endpoint.
This resource module is also used by the
[workspace pattern module](https://registry.terraform.io/modules/536tech/workspace/databricks/latest).
Each repository has its own releases. Consumers select an exact tested module version.

The resource addresses match the original workspace submodule in version 0.1.1.
To migrate a direct submodule call, change its source and version. Keep the module block name.
Run `terraform init` and require a plan with no resource changes.
DataTF exports continue to use the workspace pattern module and its existing import addresses.

## Development

Use Terraform 1.7 or later for the mock tests. The module supports Terraform 1.5 or later.

```sh
prek install
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test
tflint --recursive
prek run --all-files
```

CI tests the committed provider version and the minimum supported provider, 1.128.0.
The workspace pattern module checks the complete DataTF contract and its integration behavior.

## License

[Apache-2.0](LICENSE).

## Input safeguards

The module rejects blank required names and invalid access inputs during the plan.
Cross-input preconditions preserve the Terraform 1.5 minimum and existing resource addresses.
Null remains valid for inputs where the provider supplies a default.
Provider and API checks still apply. These checks do not prove complete permission visibility.

Each grant needs one unique principal and at least one nonblank privilege.
The module does not freeze the Unity Catalog privilege list; the provider and API check supported privileges.
`databricks_grants` manages the complete direct grant set on the object.
Preserve the caller's required grants and review the plan before apply.
Empty grants omit the grant resource; they do not declare an empty authoritative grant set.
See [provider grant semantics](https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/resources/grants.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) (resource)
- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)

## Required Inputs

The following input variables are required:

### isolation\_mode

Description: Catalog isolation mode: OPEN or ISOLATED.

Type: `string`

### name

Description: Catalog name.

Type: `string`

### owner

Description: Catalog owner. A user, group, or service principal.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### comment

Description: Catalog description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the catalog while it still contains schemas.

Type: `bool`

Default: `false`

### grants

Description: Direct catalog grants. A list permits computed service principal application IDs.

Type:

```hcl
list(object({
    principal  = string
    privileges = list(string)
  }))
```

Default: `[]`

### properties

Description: Catalog properties.

Type: `map(string)`

Default: `null`

### storage\_root

Description: Managed storage location for the catalog. Changing it replaces the catalog.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: Catalog id.

### name

Description: Catalog name.
<!-- END_TF_DOCS -->
