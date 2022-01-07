resource "digitalocean_kubernetes_cluster" "prod" {
  name    = "demo-prod"
  region  = "fra1"
  version = local.kubernetes_prod_version
  node_pool {
    name       = "demo-prod"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

output "kubeconfig-prod" {
  value     = digitalocean_kubernetes_cluster.prod.kube_config.0.raw_config
  sensitive = true
}
