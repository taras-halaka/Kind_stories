provider "kubernetes" {
  config_path = "~/.kube/config"
}


# resource "kubernetes_manifest" "nginx" {
#   manifest = file("deployment.yaml")
# }
resource "kubernetes_manifest" "test" {
  manifest = yamldecode(file("${path.module}/deployment.yaml"))
}