serviceAccount:
  create: true
  name: ${service_name}

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPU: "60"
  targetMemory: ""
  behavior: {}

service:
  type: NodePort
ingress:
  enabled: true
  hosts: []
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/scheme: internet-facing