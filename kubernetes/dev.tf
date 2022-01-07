resource "digitalocean_kubernetes_cluster" "dev" {
  name    = "demo-dev"
  region  = "fra1"
  version = local.kubernetes_dev_version
  node_pool {
    name       = "demo-dev"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

resource "digitalocean_loadbalancer" "dev" {
  name   = digitalocean_kubernetes_cluster.dev.name
  region = "fra1"

  droplet_tag = "k8s:${digitalocean_kubernetes_cluster.dev.id}"

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

resource "cloudflare_record" "k8s-dev" {
  zone_id = local.zone_id
  name    = "k8s-dev"
  value   = digitalocean_loadbalancer.dev.ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "k8s-dev-wildcard" {
  zone_id = local.zone_id
  name    = "*.k8s-dev"
  value   = cloudflare_record.k8s-dev.hostname
  type    = "CNAME"
  proxied = false
}

output "kubeconfig-dev" {
  value     = digitalocean_kubernetes_cluster.dev.kube_config.0.raw_config
  sensitive = true
}

output "lb-ip-dev" {
  value = digitalocean_loadbalancer.dev.ip
}
