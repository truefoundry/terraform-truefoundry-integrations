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
| [null_resource.create_output_dir](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.cluster_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Cloud provider account ID | `string` | n/a | yes |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authentication | `string` | n/a | yes |
| <a name="input_cluster_integration_enabled"></a> [cluster\_integration\_enabled](#input\_cluster\_integration\_enabled) | Flag to enable/disable cluster integration | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster to create | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of cluster to create | `string` | n/a | yes |
| <a name="input_control_plane_url"></a> [control\_plane\_url](#input\_control\_plane\_url) | URL of the control plane | `string` | n/a | yes |
| <a name="input_ecr_enabled"></a> [ecr\_enabled](#input\_ecr\_enabled) | Flag to enable/disable ECR integration | `bool` | `false` | no |
| <a name="input_parameter_store_enabled"></a> [parameter\_store\_enabled](#input\_parameter\_store\_enabled) | Flag to enable/disable Parameter Store integration | `bool` | `false` | no |
| <a name="input_platform_iam_role_arn"></a> [platform\_iam\_role\_arn](#input\_platform\_iam\_role\_arn) | ARN of the IAM role for the platform | `string` | n/a | yes |
| <a name="input_platform_user_access_key"></a> [platform\_user\_access\_key](#input\_platform\_user\_access\_key) | AWS access key for the platform user | `string` | n/a | yes |
| <a name="input_platform_user_bucket_name"></a> [platform\_user\_bucket\_name](#input\_platform\_user\_bucket\_name) | Name of the S3 bucket for platform user | `string` | n/a | yes |
| <a name="input_platform_user_enabled"></a> [platform\_user\_enabled](#input\_platform\_user\_enabled) | Flag to enable/disable platform user | `bool` | n/a | yes |
| <a name="input_platform_user_secret_key"></a> [platform\_user\_secret\_key](#input\_platform\_user\_secret\_key) | AWS secret key for the platform user | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region name | `string` | n/a | yes |
| <a name="input_s3_enabled"></a> [s3\_enabled](#input\_s3\_enabled) | Flag to enable/disable S3 integration | `bool` | `false` | no |
| <a name="input_secrets_manager_enabled"></a> [secrets\_manager\_enabled](#input\_secrets\_manager\_enabled) | Flag to enable/disable Secrets Manager integration | `bool` | `false` | no |
| <a name="input_trigger_helm_update"></a> [trigger\_helm\_update](#input\_trigger\_helm\_update) | Trigger Helm update | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | The token for the cluster |
| <a name="output_tenant_name"></a> [tenant\_name](#output\_tenant\_name) | The name of the tenant |
<!-- END_TF_DOCS -->