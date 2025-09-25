{
    "manifest": {
    "name": "${cluster_name}",
    "type": "cluster",
    "collaborators": [
        {
        "role_id": "cluster-admin",
        "subject": "user:tfy-user@truefoundry.com"
        }
    ],
    "cluster_type": "${cluster_type}",
    "environment_names": ["${env_name}"]
    %{ if provider_integration_enabled }
    %{ if container_registry_enabled },
    "default_registry_fqn": "${tenant_name}:${account_type}:${cluster_name}:docker-registry:registry"
    %{ endif }
    %{ if cluster_integration_enabled },
    "cluster_integration_fqn": "${tenant_name}:${account_type}:${cluster_name}:cluster:cluster-integration"
    %{ endif }
    %{ endif }
    }
}