# lekarna-cz-terraform-example

## Example of TF state mv

```
terraform state mv cloudflare_record.k8s module.k8s--prod.cloudflare_record.main
terraform state mv cloudflare_record.k8s-dev module.k8s--dev.cloudflare_record.main
terraform state mv cloudflare_record.k8s-dev-wildcard module.k8s--dev.cloudflare_record.main-wildcard
terraform state mv cloudflare_record.k8s-wildcard module.k8s--prod.cloudflare_record.main-wildcard
terraform state mv digitalocean_kubernetes_cluster.dev module.k8s--dev.digitalocean_kubernetes_cluster.main
terraform state mv digitalocean_kubernetes_cluster.prod module.k8s--prod.digitalocean_kubernetes_cluster.main
terraform state mv digitalocean_loadbalancer.dev module.k8s--dev.digitalocean_loadbalancer.main
terraform state mv digitalocean_loadbalancer.prod module.k8s--prod.digitalocean_loadbalancer.main
```
