variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster (required)"
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (required)"
}

variable "zone" {
  type        = string
  description = "The zone to host the cloud sql instance in (required)"
  default     = null
}

variable "project_number" {
  type        = string
  description = "The project number to host the cluster in (required)"
}

variable "prefix" {
  type        = string
  description = "Prefix that will be used for each created resource"
  default     = "wp"
}
