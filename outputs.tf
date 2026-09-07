output "id" {
  description = "Catalog id."
  value       = databricks_catalog.this.id
}

output "name" {
  description = "Catalog name."
  value       = databricks_catalog.this.name
}
