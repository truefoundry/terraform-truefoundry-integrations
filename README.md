# terraform-truefoundry-integrations
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.create_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.cluster_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_account_id"></a> [cloud\_account\_id](#input\_cloud\_account\_id) | Cloud provider account ID/Project ID/Subscription ID | `string` | n/a | yes |
| <a name="input_cloud_region"></a> [cloud\_region](#input\_cloud\_region) | Cloud provider region name | `string` | n/a | yes |
| <a name="input_cluster_integration_enabled"></a> [cluster\_integration\_enabled](#input\_cluster\_integration\_enabled) | Flag to enable/disable cluster integration | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster to create | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of cluster to create | `string` | n/a | yes |
| <a name="input_container_registry_enabled"></a> [container\_registry\_enabled](#input\_container\_registry\_enabled) | Flag to enable/disable container registry integration (ECR/GCR/ACR) | `bool` | `false` | no |
| <a name="input_control_plane_url"></a> [control\_plane\_url](#input\_control\_plane\_url) | URL of the control plane | `string` | n/a | yes |
| <a name="input_key_vault_enabled"></a> [key\_vault\_enabled](#input\_key\_vault\_enabled) | Flag to enable/disable key vault integration (Secrets Manager/KMS/Key Vault) | `bool` | `false` | no |
| <a name="input_object_store_bucket_name"></a> [object\_store\_bucket\_name](#input\_object\_store\_bucket\_name) | Name of the object storage bucket | `string` | n/a | yes |
| <a name="input_object_store_enabled"></a> [object\_store\_enabled](#input\_object\_store\_enabled) | Flag to enable/disable object storage integration (S3/GCS/Blob Storage) | `bool` | `false` | no |
| <a name="input_secret_store_enabled"></a> [secret\_store\_enabled](#input\_secret\_store\_enabled) | Flag to enable/disable secret store integration (Parameter Store/Secret Manager/Key Vault) | `bool` | `false` | no |
| <a name="input_service_account_enabled"></a> [service\_account\_enabled](#input\_service\_account\_enabled) | Flag to enable/disable service account/platform user | `bool` | n/a | yes |
| <a name="input_service_account_key_id"></a> [service\_account\_key\_id](#input\_service\_account\_key\_id) | Cloud provider service account key ID/access key/client ID | `string` | n/a | yes |
| <a name="input_service_account_key_secret"></a> [service\_account\_key\_secret](#input\_service\_account\_key\_secret) | Cloud provider service account key secret/access secret/client secret | `string` | n/a | yes |
| <a name="input_service_account_role_arn"></a> [service\_account\_role\_arn](#input\_service\_account\_role\_arn) | Cloud provider service account role ARN/role ID/role name | `string` | n/a | yes |
| <a name="input_tfy_api_key"></a> [tfy\_api\_key](#input\_tfy\_api\_key) | API key for authentication | `string` | n/a | yes |
| <a name="input_trigger_helm_update"></a> [trigger\_helm\_update](#input\_trigger\_helm\_update) | Trigger Helm update | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | The token for the cluster |
| <a name="output_tenant_name"></a> [tenant\_name](#output\_tenant\_name) | The name of the tenant |
<!-- END_TF_DOCS -->