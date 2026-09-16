variable "name" {
  description = "Catalog name."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.name)) > 0, false)
    error_message = "name must not be empty or blank."
  }
}

variable "isolation_mode" {
  description = "Catalog isolation mode: OPEN or ISOLATED."
  type        = string

  validation {
    condition     = var.isolation_mode == null ? true : contains(["OPEN", "ISOLATED"], var.isolation_mode)
    error_message = "isolation_mode must be OPEN or ISOLATED."
  }
}

variable "owner" {
  description = "Catalog owner. A user, group, or service principal."
  type        = string

  validation {
    condition     = var.owner == null ? true : try(length(trimspace(var.owner)) > 0, false)
    error_message = "owner must not be empty or blank."
  }
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
  default  = []
  nullable = false

  validation {
    condition = try(alltrue([for grant in var.grants :
      length(trimspace(grant.principal)) > 0 && length(grant.privileges) > 0 &&
      alltrue([for privilege in grant.privileges : length(trimspace(privilege)) > 0])
    ]) && length(distinct([for grant in var.grants : grant.principal])) == length(var.grants), false)
    error_message = "Each grant needs a unique nonblank principal and at least one nonblank privilege."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete the catalog while it still contains schemas."
  type        = bool
  default     = false
}
