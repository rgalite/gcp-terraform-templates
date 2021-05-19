locals {
  cloudsql_proxy_service_account_name = "cloudsql-proxy"
  compute_engine_service_account      = "${var.project_number}-compute@developer.gserviceaccount.com"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.kubernetes_endpoint}"
  token                  = module.gke.raw_client_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "cloudsql_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  names         = [local.cloudsql_proxy_service_account_name]
  project_id    = var.project_id
}

module "project-iam-bindings" {
  source            = "terraform-google-modules/iam/google//modules/projects_iam"
  projects          = [var.project_id]
  bindings          = {
    "roles/cloudsql.client" = [
      module.cloudsql_service_account.iam_email
    ]
  }
}

module "subnetwork" {
  source  = "./modules/subnetwork"
  name    = var.subnetwork
  network = var.network
  region  = var.region
  project = var.project_id
}

module "gke" {
  source                          = "./modules/gke"
  ip_range_pods                   = "${module.subnetwork.name}-gke-pods"
  ip_range_services               = "${module.subnetwork.name}-gke-services"
  network                         = var.network
  region                          = var.region
  subnetwork                      = module.subnetwork.name
  project_id                      = var.project_id
  compute_engine_service_account  = local.compute_engine_service_account
}

module "kube" {
  source = "./modules/kube"
}
