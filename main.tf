resource "databricks_catalog" "this" {
  name           = var.name
  isolation_mode = var.isolation_mode
  owner          = var.owner
  comment        = var.comment
  storage_root   = var.storage_root
  properties     = var.properties
  force_destroy  = var.force_destroy
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0

  catalog = databricks_catalog.this.name

  dynamic "grant" {
    for_each = var.grants

    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
