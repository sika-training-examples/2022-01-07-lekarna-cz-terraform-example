resource "digitalocean_ssh_key" "ci" {
  name       = "ci"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZY3Wka3cOU7HHZwyRnExjj8gb11wRu6TLu6l2jSrha+GMh3zDJShhMawAiQ83jwY+rQPSNx6/myiRa1Yr/tatEJUff8O9XDT7Is6RDDV+qZ02HM6sg40DSArqI8fAFFCqVT8R1JHWJV0eLe3ijmZFP7C7snEHNdqLY8uvAsXgZ02BslcgGnOeeP4dZxxWlfJLFe+JgbFvd8sp5yiA70X2Dvgu5+XtuPJabR39uMrVIxPnxlXxbepIaCU3Yj2ruEvHgAQRSIrvqmkxtv6xVzTyzVmM/H4SfQ2JTZ1qOn7l0c+KQ49JHIZKZC4wxjH69bTOwuOFBUB5aRDbjsV7BYrBMDpfKjs/xcF/gK5rD/ibwJxbDXu7lLj/FOsihHVj/WgJvxvOYnyDZLVjPgD0jenVuk00jB5AgKsS9wMiVgjbPyMuVqAj3pgEARqkSFNs3+rBBpUKJxvU7sGGoFooVdTvlM1uIHRRL1hbQDj46X8wDpw7stXLE+1DXMIVC8xgaps="
}

data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

locals {
  ssh_keys = [
    digitalocean_ssh_key.ci.id,
    data.digitalocean_ssh_key.ondrejsika.id,
  ]
}
