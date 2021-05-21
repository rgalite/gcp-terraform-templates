data "google_client_config" "default" {}

locals {
  compute_engine_service_account = "${var.project_number}-compute@developer.gserviceaccount.com"
}

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google"
  project_id               = var.project_id
  name                     = "${var.prefix}-${var.cluster_name}"
  regional                 = true
  region                   = var.region
  network                  = var.network
  subnetwork               = var.subnetwork
  ip_range_pods            = "${var.subnetwork}-gke-pods"
  ip_range_services        = "${var.subnetwork}-gke-services"
  create_service_account   = false
  service_account          = local.compute_engine_service_account
  remove_default_node_pool = true

  depends_on = [
    module.project_services
  ]
}
