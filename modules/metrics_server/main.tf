resource "helm_release" "prometheus" {
  chart            = "metrics-server"
  version          = var.addon_version
  name             = "metrics-server"
  namespace        = "metrics-server"
  create_namespace = true
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
}
