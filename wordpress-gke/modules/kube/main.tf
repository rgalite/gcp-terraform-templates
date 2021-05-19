resource "kubernetes_deployment" "wp-deployment" {
  metadata {
    name = "wp-deployment"
    labels = {
      app = "wp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wp"
      }
    }

    template {
      metadata {
        labels = {
          app = "wp"
        }
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress"

          env {
            name = "WORDPRESS_DB_HOST"
            value = "127.0.0.1:3306"
          }

          env {
            name = "WORDPRESS_DB_USER"

            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key = "username"
              }
            }
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "cloudsql-db-credentials"
                key = "password"
              }
            }
          }
        }
      }
    }
  }
}
