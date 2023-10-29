# Learn Terraform - Provision AKS Cluster

This repo is a companion repo to the [Provision an AKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks), containing Terraform configuration files to provision an AKS cluster on Azure.

Configure kubectl
```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```


Access Kubernetes Dashboard
```
az aks browse --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```