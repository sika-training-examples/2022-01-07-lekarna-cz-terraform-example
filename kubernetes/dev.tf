module "k8s--dev" {
  source             = "../modules/k8s"
  name               = "demo-dev"
  record             = "k8s-dev"
  zone_id            = local.zone_id
  kubernetes_version = local.kubernetes_dev_version
}
