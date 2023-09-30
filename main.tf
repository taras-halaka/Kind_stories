####
# created based on https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started
# 
#  to use, first attempt is to create kind cluster, second attempt will apply deployment
#
#
#  when finished, kind cluster should be deleted
####


terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.2.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# Define the Kubernetes cluster using Kind
resource "null_resource" "create_kind_cluster" {
  provisioner "local-exec" {
    command = "kind create cluster --name=my-cluster"
  }
}

# Wait for the cluster to be created before proceeding
resource "null_resource" "wait_for_kind_cluster" {
  depends_on = [null_resource.create_kind_cluster]

  provisioner "local-exec" {
    command = "sleep 30" # You can adjust the sleep duration as needed
  }
}

# Configure kubectl to use the Kind cluster
resource "null_resource" "configure_kubectl" {
  depends_on = [null_resource.wait_for_kind_cluster]

  provisioner "local-exec" {
    command = "kubectl cluster-info --context kind-my-cluster"
  }
}
resource "null_resource" "use-context_kubectl" {
  depends_on = [null_resource.wait_for_kind_cluster]

  provisioner "local-exec" {
    command = "kubectl config use-context kind-my-cluster"
  }
}



provider "kubernetes" {
  config_path    = "~/.kube/config"  # Replace with the correct absolute path
  #config_context = "kind-my-cluster"
}


# Define a Kubernetes Deployment
resource "kubernetes_deployment" "example_deployment" {
  depends_on = [null_resource.configure_kubectl,null_resource.use-context_kubectl]

  metadata {
    name = "example-deployment"
    labels = {
      app = "example"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        app = "example"
      }
    }

    template {
      metadata {
        labels = {
          app = "example"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "example-container"
        }
      }
    }
  }
}
