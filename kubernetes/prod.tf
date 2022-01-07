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

resource "digitalocean_loadbalancer" "prod" {
  name   = digitalocean_kubernetes_cluster.prod.name
  region = "fra1"

  droplet_tag = "k8s:${digitalocean_kubernetes_cluster.prod.id}"

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 80
    target_port     = 80
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 443
    target_port     = 443
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }
}

resource "cloudflare_record" "k8s" {
  zone_id = local.zone_id
  name    = "k8s"
  value   = digitalocean_loadbalancer.prod.ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "k8s-wildcard" {
  zone_id = local.zone_id
  name    = "*.k8s"
  value   = cloudflare_record.k8s.hostname
  type    = "CNAME"
  proxied = false
}

output "kubeconfig-prod" {
  value     = digitalocean_kubernetes_cluster.prod.kube_config.0.raw_config
  sensitive = true
}

output "lb-ip-prod" {
  value = digitalocean_loadbalancer.prod.ip
}
