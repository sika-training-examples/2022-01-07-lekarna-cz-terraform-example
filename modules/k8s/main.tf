# ===== Terraform =====

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# ===== Variables =====

variable "name" {
  type        = string
  description = "Name of Kubernetes cluster"
}

variable "record" {
  type        = string
  description = "Name of DNS record poited to Kuberrnetes (LoadBalancer)"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "region" {
  type    = string
  default = "fra1"
}

variable "version" {
  type        = string
  description = "Version of Kubernetes"
}

variable "node_size" {
  type    = string
  default = "s-2vcpu-2gb"
}
variable "node_count" {
  type    = number
  default = 1
}

# ===== Main =====

resource "digitalocean_kubernetes_cluster" "main" {
  name    = var.name
  region  = var.region
  version = var.version
  node_pool {
    name       = var.name
    size       = var.node_size
    node_count = var.node_count
  }
}

resource "digitalocean_loadbalancer" "main" {
  name   = digitalocean_kubernetes_cluster.main.name
  region = var.region

  droplet_tag = "k8s:${digitalocean_kubernetes_cluster.main.id}"

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

resource "cloudflare_record" "main" {
  zone_id = var.zone_id
  name    = var.record
  value   = digitalocean_loadbalancer.main.ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "main-wildcard" {
  zone_id = var.zone_id
  name    = "*.${var.record}"
  value   = cloudflare_record.main.hostname
  type    = "CNAME"
  proxied = false
}

# ===== Outputs =====

output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.main.kube_config.0.raw_config
  sensitive = true
}

output "lb-ip" {
  value = digitalocean_loadbalancer.main.ip
}

output "digitalocean_kubernetes_cluster" {
  value     = digitalocean_kubernetes_cluster.main
  sensitive = true
}

output "digitalocean_loadbalancer" {
  value = digitalocean_loadbalancer.main
}
