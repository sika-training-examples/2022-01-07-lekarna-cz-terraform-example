module "k8s--prod" {
  source             = "../modules/k8s"
  name               = "demo-prod"
  record             = "k8s"
  zone_id            = local.zone_id
  kubernetes_version = local.kubernetes_prod_version
}
