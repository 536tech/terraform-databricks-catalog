mock_provider "databricks" {}

variables {

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

run "documented_example" {
  command = apply

  assert {
    condition     = databricks_catalog.this.name == var.name
    error_message = "The resource must preserve its configured name."
  }

  assert {
    condition     = length(databricks_grants.this) == 1
    error_message = "Configured access must have stable resource addresses."
  }
}

run "without_access" {
  command = plan

  variables {
    grants = []
  }

  assert {
    condition     = length(databricks_grants.this) == 0
    error_message = "Empty access must omit the access resources."
  }
}
