# Plan-only test for generic cluster_type support.
#
# The module's external data sources call the control-plane API via bash
# (get_environment → create_cluster). mock_provider replaces them so the test
# runs offline. A passing `command = plan` for cluster_type="generic" is itself
# the regression guard: it proves local.cluster_template["generic"] /
# local.provider_account_template["generic"] resolve and their templatefiles
# render — the path that previously errored before generic support was added.

mock_provider "external" {
  mock_data "external" {
    defaults = {
      result = {
        environment_name = "test-env"
        tenant_name      = "test-tenant"
        cluster_id       = "clstr-123"
        cluster_token    = "tok-abc"
      }
    }
  }
}

run "generic_compute_plane" {
  command = plan

  variables {
    control_plane_url = "https://cp.example.com"
    tfy_api_key       = "tfy.test.key"
    tenant_name       = "test-tenant"
    cluster_name      = "generic-test"
    cluster_type      = "generic"
  }

  # A generic (bring-your-own) cluster has no cloud provider account to wire.
  assert {
    condition     = output.provider_integration_enabled == false
    error_message = "generic clusters must have provider integration disabled"
  }

  # create_cluster wiring resolves (id comes from the mocked data source).
  assert {
    condition     = output.cluster_id == "clstr-123"
    error_message = "expected cluster_id to be wired from the create_cluster data source"
  }

  # get_environment wiring resolves.
  assert {
    condition     = output.tenant_name == "test-tenant"
    error_message = "expected tenant_name to be wired from the get_environment data source"
  }
}

run "generic_ignores_cloud_feature_flags" {
  command = plan

  variables {
    control_plane_url                  = "https://cp.example.com"
    tfy_api_key                        = "tfy.test.key"
    tenant_name                        = "test-tenant"
    cluster_name                       = "generic-test"
    cluster_type                       = "generic"
    aws_platform_features_user_enabled = true
  }

  # cluster_type=generic takes precedence over any cloud feature flags —
  # provider integration stays off (guards the provider_integration_enabled
  # ternary ordering).
  assert {
    condition     = output.provider_integration_enabled == false
    error_message = "generic must disable provider integration regardless of cloud feature flags"
  }
}
