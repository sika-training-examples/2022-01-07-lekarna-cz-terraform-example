data "digitalocean_droplet_snapshot" "gitlab" {
  name        = "gitlab"
  region      = "fra1"
  most_recent = true
}

resource "digitalocean_floating_ip" "gitlab" {
  region = "fra1"
}

resource "digitalocean_vpc" "gitlab" {
  name     = "gitlab"
  region   = "fra1"
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_droplet" "gitlab" {
  image    = data.digitalocean_droplet_snapshot.gitlab.id
  name     = "gitlab"
  region   = "fra1"
  size     = "s-8vcpu-16gb"
  ssh_keys = local.ssh_keys
  vpc_uuid = digitalocean_vpc.gitlab.id
}

resource "digitalocean_floating_ip_assignment" "gitlab" {
  ip_address = digitalocean_floating_ip.gitlab.ip_address
  droplet_id = digitalocean_droplet.gitlab.id
}

resource "cloudflare_record" "gitlab" {
  zone_id = local.zone_id
  name    = "gitlab"
  value   = digitalocean_floating_ip.gitlab.ip_address
  type    = "A"
  proxied = false
}

output "gitlab-ip" {
  value = digitalocean_floating_ip.gitlab.ip_address
}
output "gitlab-domain" {
  value = cloudflare_record.gitlab.hostname
}
