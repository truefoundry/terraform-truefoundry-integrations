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
    }
}