image:
  repository: public.ecr.aws/eks/aws-load-balancer-controller

serviceAccount:
  create: true
  name: ${service_name}

clusterName: ${cluster_name}
region: ${region}
vpcId: ${vpc_id}