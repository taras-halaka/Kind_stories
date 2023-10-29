provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your Kubernetes config
}

resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = "wordpress-namespace"
  }
}

resource "kubernetes_secret" "wordpress-secrets" {
  metadata {
    name      = "wordpress-secrets"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  data = {
    MYSQL_ROOT_PASSWORD = base64encode("rootpassword222"),
    MYSQL_DATABASE      = "DB222" # base64encode("DB222"),
    MYSQL_USER          = "user222" #base64encode("user222"),
    MYSQL_PASSWORD      = base64encode("password222"),
  }
}

 resource "kubernetes_persistent_volume" "mysql-pv" {
   metadata {
     name = "mysql-pv"
   }
   spec {
     capacity = {
       storage = "3Gi"
     }
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"
     persistent_volume_source {
         host_path {
         path = "/tmp/mysql-data"
         }  
     }    
   }
 }

resource "kubernetes_persistent_volume_claim" "mysql-pvc" {
  metadata {
    name      = "mysql-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"
    resources {
      requests = {
        storage = "3Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql-deployment"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        container {
          name  = "mysql"
          image = "mysql:latest"
          port {
            container_port = 3306
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.wordpress-secrets.metadata[0].name
                key  = "MYSQL_ROOT_PASSWORD"
              }
            }
          }
          env {
            name  = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.wordpress-secrets.metadata[0].name
                key  = "MYSQL_DATABASE"
              }
            }
          }
          env {
            name  = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.wordpress-secrets.metadata[0].name
                key  = "MYSQL_USER"
              }
            }
          }          
          env {
            name  = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.wordpress-secrets.metadata[0].name
                key  = "MYSQL_PASSWORD"
              }
            }
          }
          
              
          # env{
          #   name =  "MYSQL_DATABASE"
          #   value = "DB222"
          # }
          # env{
          #   name = "MYSQL_USER"
          #   value = "user222"
          # }
          # env{
          #   name = "MYSQL_PASSWORD"
          #   value = "password222"
          # }
          # env {
          #   name  = "MYSQL_DATABASE"
          #   value_from {
          #     secret_key_ref {
          #       name = kubernetes_secret.wordpress-secrets.metadata[0].name
          #       key  = "MYSQL_DATABASE"
          #     }
          #   }
          # }
          # env {
          #   name  = "MYSQL_USER"
          #   value_from {
          #     secret_key_ref {
          #       name = kubernetes_secret.wordpress-secrets.metadata[0].name
          #       key  = "MYSQL_USER"
          #     }
          #   }
          # }
          # env {
          #   name  = "MYSQL_PASSWORD"
          #   value_from {
          #     secret_key_ref {
          #       name = kubernetes_secret.wordpress-secrets.metadata[0].name
          #       key  = "MYSQL_PASSWORD"
          #     }
          #   }
          # }                               
          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }
        }
        volume {
          name = "mysql-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mysql-pvc.metadata[0].name
          }
        }
      }
    }
  }
    depends_on = [ kubernetes_secret.wordpress-secrets ]
}

#  resource "kubernetes_service" "mysql" {
#    metadata {
#      name      = "mysql-exposed"
#      namespace = kubernetes_namespace.wordpress.metadata[0].name
#    }
#    spec {
#      selector = {
#          app = kubernetes_deployment.mysql.metadata[0].name
#      }
#      port {
#             name       = "mysql"
#             protocol   = "TCP"
#             port = 3306
#             target_port = 3306
#            }
#      #type = "ClusterIP"
#      #type = "NodePort"
#    }
#    depends_on = [ kubernetes_deployment.mysql ]
#  }

resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql-exposed"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }
  spec {
    selector = {
      #app = kubernetes_deployment.mysql.metadata[0].labels.app  # Match the label of your MySQL Deployment
      app = "mysql"  # Match the label of your MySQL Deployment
    }
    port {
      name       = "mysql"
      protocol   = "TCP"
      port       = 3306
      target_port = 3306
    }
  }
  depends_on = [kubernetes_deployment.mysql]
}





 resource "kubernetes_persistent_volume" "wordpress-pv" {
   metadata {
     name = "wordpress-pv"
   }
   spec {
     capacity = {
       storage = "2Gi"
     }
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"
     persistent_volume_source {
         host_path {
         path = "/tmp/wordpress-data"
         }  
     }
   }
 }

resource "kubernetes_persistent_volume_claim" "wordpress-pvc" {
  metadata {
    name      = "wordpress-pvc"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"
    resources {
      requests = {
        storage = "2Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name      = "wordpress-deployment"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
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
          name  = "wordpress"
          #image = "wordpress:latest"
          image = "wordpress:6.2.1-apache"

          env {
              name  = "WORDPRESS_DB_HOST"
              value = kubernetes_service.mysql.metadata[0].name  # Replace with the actual service name of MySQL
            }
          env{
            name =  "WORDPRESS_DB_NAME"
            value = "DB222"
          }

                    
          # env{
          #   name = "WORDPRESS_DB_USER"
          #   value = "user222"
          # }
          # env{
          #   name = "WORDPRESS_DB_PASSWORD"
          #   value = "password222"
          # }

          env {
            name  = "WORDPRESS_DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.wordpress-secrets.metadata[0].name
                key  = "MYSQL_USER"
              }
            }
          }          
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.wordpress-secrets.metadata[0].name
                key  = "MYSQL_PASSWORD"
                #key = "MYSQL_ROOT_PASSWORD"
              }
            }
          }


          # env {
          #     name  = "WORDPRESS_DB_HOST"
          #     value = kubernetes_service.mysql.metadata[0].name  # Replace with the actual service name of MySQL
          #   }
          # env {
          #   name  = "WORDPRESS_DB_NAME"
          #   value_from {
          #     secret_key_ref {
          #       name = kubernetes_secret.wordpress-secrets.metadata[0].name
          #       key  = "MYSQL_DATABASE"
          #     }
          #   }
          # }
          # env {
          #   name  = "WORDPRESS_DB_USER"
          #   value = "${kubernetes_secret.wordpress-secrets.data["MYSQL_USER"]}"
          # }            
          # env {
          #   name  = "WORDPRESS_DB_PASSWORD"
          #   #value = "${kubernetes_secret.wordpress-secrets.data["MYSQL_PASSWORD"]}"
          #       value_from {
          #         secret_key_ref {
          #           name = kubernetes_secret.wordpress-secrets.metadata[0].name
          #           key  = "MYSQL_PASSWORD"
          #         }
          #       }        
          #     }   

          port {
            container_port = 80
          }

          volume_mount {
            name       = "wordpress-data"
            mount_path = "/var/www/html"
          }
        }
        volume {
          name = "wordpress-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wordpress-pvc.metadata[0].name
          }
        }
      }
    }
    
  }
  depends_on = [ kubernetes_deployment.mysql, kubernetes_service.mysql ]
}


# Define the WordPress Service
resource "kubernetes_service" "wordpress_service" {
  metadata {
    name      = "wordpress-service"
    namespace = kubernetes_namespace.wordpress.metadata.0.name
  }

  spec {
    selector = {
      app = "wordpress"
      #app = kubernetes_namespace.wordpress.metadata[0].name #spec.template.metadata[0].labels[0].app
    }

    port {
      name       = "http"
      protocol   = "TCP"
      port       = 80
      target_port = 80
    }
    #type = "NodePort"
    #type = ClusterIP
    # will publish service on AKS cluster
    type = "LoadBalancer"
  }
  depends_on = [ kubernetes_deployment.mysql, kubernetes_secret.wordpress-secrets, kubernetes_service.mysql, kubernetes_deployment.wordpress ]
}