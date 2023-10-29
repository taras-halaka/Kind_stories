# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}
variable "displayName" {
  description = "Azure Kubernetes Service Cluster displayName"
}

variable "tenant" {
  description = "Azure Kubernetes Service Cluster tenant"
}
