module "ebs_csi_driver" {
  source = "./modules/aws_ebs_csi"

  cluster_name = module.eks.cluster_name
}

module "aws_load_balancer_controller" {
  source = "./modules/aws_load_balancer_controller"

  addon_version  = "1.8.1"
  namespace      = "kube-system"
  cluster_name   = module.eks.cluster_name
  cluster_vpc_id = module.vpc.vpc_id
  region         = var.region
}

module "metrics_server" {
  source = "./modules/metrics_server"

  addon_version = "3.12.1"
  cluster_name  = module.eks.cluster_name
}
