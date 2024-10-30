name: ${cluster_name}
type: cluster
monitoring:
  loki_url: http://loki.loki.svc.cluster.local:3100
  prometheus_url: http://prometheus-operated.prometheus.svc.cluster.local:9090
cluster_type: ${cluster_type}
collaborators:
- role_id: cluster-admin
  subject: user:tfy-user@truefoundry.com