locals {
  cloudsql_proxy_service_account_name = "cloudsql-proxy"
}

module "cloudsql_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  names         = [local.cloudsql_proxy_service_account_name]
  project_id    = var.project_id
  generate_keys = true
}
