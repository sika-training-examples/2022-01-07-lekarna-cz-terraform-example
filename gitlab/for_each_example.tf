module "vm--runners2" {
  source  = "ondrejsika/ondrejsika-do-droplet/module"
  version = "1.2.0"

  for_each = toset(["foo", "bar", "baz"])

  droplet_name = "runner-${each.key}"
  record_name  = "runner-${each.key}"
  tf_ssh_keys  = local.ssh_keys
  vpc_uuid     = digitalocean_vpc.gitlab.id
  zone_id      = local.zone_id
}


output "runner2-ips" {
  value = [
    for m in module.vm--runners2 :
    m.droplet.ipv4_address
  ]
}

output "runner2-domains" {
  value = [
    for m in module.vm--runners2 :
    m.record.hostname
  ]
}
