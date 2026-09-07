variable "name" {
  description = "Catalog name."
  type        = string
}

variable "isolation_mode" {
  description = "Catalog isolation mode: OPEN or ISOLATED."
  type        = string
}

variable "owner" {
  description = "Catalog owner. A user, group, or service principal."
  type        = string
}

variable "comment" {
  description = "Catalog description."
  type        = string
  default     = null
}

variable "storage_root" {
  description = "Managed storage location for the catalog. Changing it replaces the catalog."
  type        = string
  default     = null
}

variable "properties" {
  description = "Catalog properties."
  type        = map(string)
  default     = null
}

variable "grants" {
  description = "Direct catalog grants. A list permits computed service principal application IDs."
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}

variable "force_destroy" {
  description = "Allow Terraform to delete the catalog while it still contains schemas."
  type        = bool
  default     = false
}
