data "google_client_config" "default" {}

module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = var.project_id
  name                        = "wp-cluster"
  regional                    = true
  region                      = var.region
  network                     = var.network
  subnetwork                  = var.subnetwork
  ip_range_pods               = var.ip_range_pods
  ip_range_services           = var.ip_range_services
  create_service_account      = false
  service_account             = var.compute_engine_service_account
  enable_binary_authorization = var.enable_binary_authorization
  skip_provisioners           = var.skip_provisioners
}
