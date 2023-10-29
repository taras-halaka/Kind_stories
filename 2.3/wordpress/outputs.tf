output "wordpress_service_ip" {
  description = "IP address of the WordPress service"
  value       = kubernetes_service.wordpress_service.spec.0.cluster_ip
}

output "mysql_service_ip" {
  description = "IP address of the WordPress service"
  value       = kubernetes_service.mysql.spec.0.cluster_ip
}
