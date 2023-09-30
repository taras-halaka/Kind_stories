terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.2.1"
    }
  }
}

provider "kind" {
  # Configuration options
  # config_path = "~/.kube/config" # Path to your Kubernetes config file
}

  resource "kind_cluster" "default" {
	    name = "kindcluster"
	    node_image = "kindest/node:v1.28.0"
	    wait_for_ready = true
    kind_config {
      kind = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
        role = "control-plane"
      }

      node {
        role = "worker"
      }
      node {
        role = "worker"
      }
      node {
        role = "worker"
      }
    }
  }