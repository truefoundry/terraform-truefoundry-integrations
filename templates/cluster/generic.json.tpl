{
    "manifest": {
    "name": "${cluster_name}",
    "type": "cluster",
    "monitoring": {
        "loki_url": "http://loki.loki.svc.cluster.local:3100",
        "prometheus_url": "http://prometheus-operated.prometheus.svc.cluster.local:9090"
    },
    "collaborators": [
        {
        "role_id": "cluster-admin",
        "subject": "user:tfy-user@truefoundry.com"
        }
    ],
    "cluster_type": "${cluster_type}",
    "environment_names": ["${env_name}"]
    }
}