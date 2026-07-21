# INFRA-1181: the cluster manifest must send an EMPTY `collaborators` list.
# Server PR #10092 dropped the requirement for a cluster-admin collaborator; this module
# previously hardcoded `user:tfy-user@truefoundry.com`, which left a stray cluster-admin
# role-binding on every provisioned cluster. The key stays required by the manifest schema
# (empty array is valid), so we send [] rather than omitting it.
#
# Plan-only. The two `data "external"` sources run shell scripts (get_environment hits the
# control-plane API, create_cluster PUTs the manifest), so both are stubbed via override_data —
# no scripts, no network. Assertions parse the rendered `local.cluster_config` with jsondecode.
# Provider feature flags are forced off so the sibling provider-account template renders without
# null interpolations; the cluster manifest under test is unaffected.

mock_provider "external" {}

variables {
  aws_s3_enabled                    = false
  aws_ecr_enabled                   = false
  aws_parameter_store_enabled       = false
  aws_secrets_manager_enabled       = false
  aws_cluster_integration_enabled   = false
  gcp_container_registry_enabled    = false
  gcp_blob_storage_enabled          = false
  gcp_secrets_manager_enabled       = false
  gcp_cluster_integration_enabled   = false
  azure_acr_enabled                 = false
  azure_blob_storage_enabled        = false
  azure_cluster_integration_enabled = false
}

override_data {
  target = data.external.get_environment
  values = {
    result = {
      environment_name = "test-env"
      tenant_name      = "test-tenant"
    }
  }
}

override_data {
  target = data.external.create_cluster
  values = {
    result = {
      cluster_id    = "cluster-test-id"
      cluster_token = "cluster-test-token"
    }
  }
}

run "aws_manifest_has_no_collaborators" {
  command = plan

  variables {
    control_plane_url              = "https://example.test"
    tfy_api_key                    = "test.test.test"
    cluster_name                   = "tfy-smoke-aws"
    cluster_type                   = "aws-eks"
    aws_account_id                 = "123456789012"
    aws_region                     = "us-east-1"
    aws_platform_features_role_arn = "arn:aws:iam::123456789012:role/tfy"
  }

  assert {
    condition     = can(jsondecode(local.cluster_config))
    error_message = "Rendered aws cluster manifest is not valid JSON"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.collaborators == []
    error_message = "aws cluster manifest collaborators must be an empty list"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.name == var.cluster_name
    error_message = "aws manifest name should equal var.cluster_name"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.cluster_type == "aws-eks"
    error_message = "aws manifest cluster_type should be aws-eks"
  }
}

run "gcp_manifest_has_no_collaborators" {
  command = plan

  variables {
    control_plane_url = "https://example.test"
    tfy_api_key       = "test.test.test"
    cluster_name      = "tfy-smoke-gcp"
    cluster_type      = "gcp-gke-standard"
    gcp_project_id    = "tfy-test-project"
    gcp_region        = "us-central1"
    gcp_sa_auth_data  = "{}"
  }

  assert {
    condition     = can(jsondecode(local.cluster_config))
    error_message = "Rendered gcp cluster manifest is not valid JSON"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.collaborators == []
    error_message = "gcp cluster manifest collaborators must be an empty list"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.cluster_type == "gcp-gke-standard"
    error_message = "gcp manifest cluster_type should be gcp-gke-standard"
  }
}

run "azure_manifest_has_no_collaborators" {
  command = plan

  variables {
    control_plane_url     = "https://example.test"
    tfy_api_key           = "test.test.test"
    cluster_name          = "tfy-smoke-azure"
    cluster_type          = "azure-aks"
    azure_subscription_id = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = can(jsondecode(local.cluster_config))
    error_message = "Rendered azure cluster manifest is not valid JSON"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.collaborators == []
    error_message = "azure cluster manifest collaborators must be an empty list"
  }

  assert {
    condition     = jsondecode(local.cluster_config).manifest.cluster_type == "azure-aks"
    error_message = "azure manifest cluster_type should be azure-aks"
  }
}
