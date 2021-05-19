resource "google_compute_subnetwork" "subnetwork" {
  name          = var.name
  ip_cidr_range = "10.10.0.0/20"
  region        = var.region
  network       = var.network
  project       = var.project
  secondary_ip_range = [
    {
      range_name    = "${var.name}-gke-pods"
      ip_cidr_range = "10.0.0.0/14"
    },
    {
      range_name    = "${var.name}-gke-services"
      ip_cidr_range = "10.4.0.0/19"
    }
  ]
}
