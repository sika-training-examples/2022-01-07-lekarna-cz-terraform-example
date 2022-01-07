module "vm--runners" {
  source  = "ondrejsika/ondrejsika-do-droplet/module"
  version = "1.2.0"

  count = 3

  droplet_name = "runner-${count.index}"
  record_name  = "runner-${count.index}"
  tf_ssh_keys  = local.ssh_keys
  vpc_uuid     = digitalocean_vpc.gitlab.id
  zone_id      = local.zone_id
}


output "runner-ips" {
  value = [
    for m in module.vm--runners :
    m.droplet.ipv4_address
  ]
}

output "runner-domains" {
  value = [
    for m in module.vm--runners :
    m.record.hostname
  ]
}
