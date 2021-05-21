module "cloudsql" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/safer_mysql"
  database_version     = "MYSQL_8_0"
  vpc_network          = "projects/${var.project_id}/global/networks/${var.network}"
  region               = var.region
  project_id           = var.project_id
  name                 = "${var.prefix}-db"
  zone                 = var.zone
  random_instance_name = true
  additional_users = [
    {
      name     = "wordpress"
      password = random_password.wp_password.result
      host     = "%"
    }
  ]
  additional_databases = [
    {
      name      = "wordpress",
      charset   = "utf8"
      collation = "utf8_unicode_ci"
    }
  ]

  depends_on = [
    module.project_services
  ]
}

resource "random_password" "wp_password" {
  length  = 16
  special = true
}
