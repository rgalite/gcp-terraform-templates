module "project_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.project_id]
  bindings = {
    "roles/cloudsql.client" = [
      module.cloudsql_service_account.iam_email
    ]
  }
}

module "project_services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  project_id = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}
