provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "kubernetes_deployment" "wp_deployment" {
  metadata {
    name = "${var.prefix}-deployment"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "127.0.0.1:3306"
          }

          env {
            name = "WORDPRESS_DB_USER"

            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key  = "username"
              }
            }
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key  = "password"
              }
            }
          }

          port {
            container_port = "80"
            name           = "wordpress"
          }

          volume_mount {
            name       = "wordpress-persistent-storage"
            mount_path = "/var/www/html"
          }
        }

        container {
          name  = "cloudsql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.17"
          command = [
            "/cloud_sql_proxy",
            "-instances=${module.cloudsql.instance_connection_name}=tcp:3306",
            "-ip_address_types=PRIVATE",
            "-credential_file=/secrets/cloudsql/key.json"
          ]

          security_context {
            run_as_user                = 2
            allow_privilege_escalation = false
          }

          volume_mount {
            name       = "cloudsql-instance-credentials"
            mount_path = "/secrets/cloudsql"
            read_only  = true
          }
        }

        volume {
          name = "wordpress-persistent-storage"

          persistent_volume_claim {
            claim_name = "wordpress-volumeclaim"
          }
        }

        volume {
          name = "cloudsql-instance-credentials"

          secret {
            secret_name = "cloudsql-instance-credentials"
          }
        }
      }
    }
  }

  wait_for_rollout = false
}

resource "kubernetes_persistent_volume_claim" "wp_volumeclaim" {
  metadata {
    name = "wordpress-volumeclaim"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "200Gi"
      }
    }
  }
}

resource "kubernetes_secret" "wp_secret" {
  metadata {
    name = "cloudsql-db-credentials"
  }

  data = {
    username = "wordpress"
    password = random_password.wp_password.result
  }

  type = "Opaque"
}

resource "kubernetes_secret" "cloudsql_instance_credentials" {
  metadata {
    name = "cloudsql-instance-credentials"
  }

  data = {
    "key.json" = module.cloudsql_service_account.key
  }

  type = "Opaque"
}

resource "kubernetes_service" "wp_service" {
  metadata {
    name = "wp-service"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    selector = {
      app = "wordpress"
    }
  }
}
