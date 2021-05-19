variable "project" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "name" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = null
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}
