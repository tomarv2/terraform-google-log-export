<p align="center">
    <a href="https://github.com/tomarv2/terraform-google-project-sink/actions/workflows/security_scans.yml" alt="Security Scans">
        <img src="https://github.com/tomarv2/terraform-google-project-sink/actions/workflows/security_scans.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="license">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-google-project-sink" /></a>
    <a href="https://github.com/tomarv2/terraform-google-project-sink/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-project-sink" /></a>
    <a href="https://github.com/tomarv2/terraform-google-project-sink/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-google-project-sink" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://discord.gg/XH975bzN" alt="chat on Discord">
        <img src="https://img.shields.io/discord/813961944443912223?logo=discord"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

# Terraform module to create Google Cloud log export

**There are four levels of log exports for Google cloud:**

:point_right: project level

:point_right: folder level

:point_right: organization level

:point_right: billing_account level

Plan correctly as there is cost associated with log export.

# Versions

- Module tested for Terraform 0.14.
- Google provider version [3.58.0](https://registry.terraform.io/providers/hashicorp/google/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-google-project-sink/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-project-sink" /></a> in your releases)

**NOTE:** 

- Read more on [tfremote](https://github.com/tomarv2/tfremote)

## Usage
Recommended method:

- Create python 3.6+ virtual environment 
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote
```

- Set below environment variables:
```
export TF_GCLOUD_BUCKET=<remote state bucket name>
export TF_GCLOUD_CREDENTIALS=<gcp credentials.json>
```  

- Updated `examples` directory to required values. 

- Run and verify the output before deploying:
```
tf -cloud gcloud plan -var='teamid=foo' -var='prjid=bar'
```

- Run below to deploy:
```
tf -cloud gcloud apply -var='teamid=foo' -var='prjid=bar'
```

- Run below to destroy:
```
tf -cloud gcloud destroy -var='teamid=foo' -var='prjid=bar'
```

> ❗️ **Important** - Two variables are required for using `tf` package:
>
> - teamid
> - prjid
>
> These variables are required to set backend path in the remote storage.
> Variables can be defined using:
>
> - As `inline variables` e.g.: `-var='teamid=demo-team' -var='prjid=demo-project'`
> - Inside `.tfvars` file e.g.: `-var-file=<tfvars file location> `
>
> For more information refer to [Terraform documentation](https://www.terraform.io/docs/language/values/variables.html)

#### Project Log Export to new PubSub topic (pull method)
```
module "project_log_export" {
  source = "git::git@github.com:tomarv2/terraform-google-log-export.git"

  gcp_project = "demo-1000"
  #----------------------------------------------
  # INCLUSION: Log all WARN or higher severity messages relating to instances
  #----------------------------------------------
  inclusion_filter = "logName = \"projects/demo-1000/logs/cloudaudit.googleapis.com%2Factivity\" AND protoPayload.methodName = (\"beta.compute.instances.insert\") AND resource.type = gce_instance AND severity >= ERROR"
 #----------------------------------------------
  # EXCLUSION
  #----------------------------------------------
  exclusions = [{
  name ="sec-eng-ex1"
  description ="Exclude logs 1"
  filter = "resource.type = gce_instance AND severity >= WARNING"
},
{
  name ="sec-eng-ex2"
  description ="Exclude logs 2"
  filter = "resource.type = gce_instance AND severity >= INFO"
}]
  #----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "pubsub" {
  source = "git::git@github.com:tomarv2/terraform-google-pubsub.git"

  gcp_project = "demo-1000"
  pull_subscriptions = [
    {
      name                 = "pull"
      ack_deadline_seconds = 10
    },
  ]
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

#### Project Log Export to exiting PubSub topic (pull method)
```
module "project_log_export" {
  source = "git::git@github.com:tomarv2/terraform-google-log-export.git"

  existing_topic_name = "projects/demo-1000/topics/delme-vt"
  gcp_project = "demo-1000"
  #----------------------------------------------
  # INCLUSION: Log all WARN or higher severity messages relating to instances
  #----------------------------------------------
  inclusion_filter = "logName = \"projects/demo-1000/logs/cloudaudit.googleapis.com%2Factivity\" AND protoPayload.methodName = (\"beta.compute.instances.insert\") AND resource.type = gce_instance AND severity >= ERROR"
 #----------------------------------------------
  # EXCLUSION
  #----------------------------------------------
  exclusions = [{
  name ="sec-eng-ex1"
  description ="Exclude logs 1"
  filter = "resource.type = gce_instance AND severity >= WARNING"
},
{
  name ="sec-eng-ex2"
  description ="Exclude logs 2"
  filter = "resource.type = gce_instance AND severity >= INFO"
}]
  #----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```

#### Project Log Export to new Storage bucket
```
module "project_log_export" {
  source = "git::git@github.com:tomarv2/terraform-google-log-export.git"

  bucket_name = module.storage_bucket.storage_bucket_name
  gcp_project = "demo-1000"
  #----------------------------------------------
  # INCLUSION: Log all WARN or higher severity messages relating to instances
  #----------------------------------------------
  inclusion_filter = "logName = \"projects/demo-1000/logs/cloudaudit.googleapis.com%2Factivity\" AND protoPayload.methodName = (\"beta.compute.instances.insert\") AND resource.type = gce_instance AND severity >= ERROR"
 #----------------------------------------------
  # EXCLUSION
  #----------------------------------------------
  exclusions = [{
  name ="sec-eng-ex1"
  description ="Exclude logs 1"
  filter = "resource.type = gce_instance AND severity >= WARNING"
},
{
  name ="sec-eng-ex2"
  description ="Exclude logs 2"
  filter = "resource.type = gce_instance AND severity >= INFO"
}]
  #----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "storage_bucket" {
  source = "git::git@github.com:tomarv2/terraform-google-storage-bucket.git"

  bucket_name = "test-prj-sink-0011"
  gcp_project = "demo-1000"
  teamid = var.teamid
  prjid  = var.prjid
}
```

#### Project Log Export to existing Storage bucket
```
module "project_log_export" {
  source = "git::git@github.com:tomarv2/terraform-google-log-export.git"

  bucket_name = "<existing bucket name>"
  gcp_project = "demo-1000"
  #----------------------------------------------
  # INCLUSION: Log all WARN or higher severity messages relating to instances
  #----------------------------------------------
  inclusion_filter = "logName = \"projects/demo-1000/logs/cloudaudit.googleapis.com%2Factivity\" AND protoPayload.methodName = (\"beta.compute.instances.insert\") AND resource.type = gce_instance AND severity >= ERROR"
 #----------------------------------------------
  # EXCLUSION
  #----------------------------------------------
  exclusions = [{
  name ="sec-eng-ex1"
  description ="Exclude logs 1"
  filter = "resource.type = gce_instance AND severity >= WARNING"
},
{
  name ="sec-eng-ex2"
  description ="Exclude logs 2"
  filter = "resource.type = gce_instance AND severity >= INFO"
}]
  #----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
```
Please refer to examples directory [link](examples) for references.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| google | ~> 3.58 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.58 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bigquery\_options | (Optional) Options that affect sinks exporting data to BigQuery. use\_partitioned\_tables - (Required) Whether to use BigQuery's partition tables. | <pre>object({<br>    use_partitioned_tables = bool<br>  })</pre> | `null` | no |
| bucket\_name | Google storage bucket name | `any` | `null` | no |
| create\_topic | Specify true if you want to create a topic | `bool` | `true` | no |
| deploy\_bucket | feature flag, true or false | `bool` | `true` | no |
| deploy\_org\_sink | feature flag, true or false | `bool` | `true` | no |
| deploy\_project\_sink | feature flag, true or false | `bool` | `true` | no |
| exclusions | n/a | <pre>set(object({<br>    name        = string<br>    description = string<br>    filter      = string<br>  }))</pre> | n/a | yes |
| gcp\_project | Name of the GCP project | `any` | n/a | yes |
| gcp\_region | n/a | `string` | `"us-central1"` | no |
| inclusion\_filter | n/a | `any` | n/a | yes |
| message\_storage\_policy | A map of storage policies. Default - inherit from organization's Resource Location Restriction policy. | `map(any)` | `{}` | no |
| parent\_resource\_id | The ID of the GCP resource in which you create the log sink. If var.parent\_resource\_type is set to 'project', then this is the Project ID (and etc). | `any` | `null` | no |
| parent\_resource\_type | The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing\_account', or 'organization'. | `string` | `"project"` | no |
| prjid | (Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| sink\_name | Google storage bucket name | `any` | `null` | no |
| teamid | (Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply' | `any` | n/a | yes |
| topic\_kms\_key\_name | The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. | `any` | `null` | no |
| topic\_name | The Pub/Sub topic name | `any` | `null` | no |
| unique\_writer\_identity | Whether or not to create a unique identity associated with this sink. If false (the default), then the writer\_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_sink\_destination | Project log sink destination |
| project\_sink\_name | Project log sink name |
| project\_sink\_project | Project log sink project |
| project\_sink\_unique\_writer\_identity | Project log sink write identity |
| project\_sink\_writer\_identfity | Project log sink write identity |

## Permissions

Service account with the following roles is required:

- On the logsink's project, folder, or organization (to create the logsink) enable:

`roles/logging.configWriter` 
  
- On the destination project (to grant write permissions for logsink service account) enable:

`roles/resourcemanager.projectIamAdmin`
  
- On the destination project (to enable destination APIs) enable:

`roles/serviceusage.serviceUsageAdmin` 
  
**Pub/Sub roles**

To use a Google Cloud Pub/Sub topic as the destination, on the destination project (to create a pub/sub topic):

`roles/pubsub.admin`
  
**Storage role**

To use a Google Cloud Storage bucket as the destination, on the destination project (to create a storage bucket):

`roles/storage.admin`

**BigQuery role**

To use a BigQuery dataset as the destination, on the destination project (to create a BigQuery dataset):

`roles/bigquery.dataEditor` 

## Project APIs

Following APIs must be enabled on the project:

Cloud Resource Manager API - `cloudresourcemanager.googleapis.com`

Cloud Billing API - `cloudbilling.googleapis.com`

Identity and Access Management API - `iam.googleapis.com`

Service Usage API - `serviceusage.googleapis.com`

Stackdriver Logging API - `logging.googleapis.com`

Cloud Storage JSON API - `storage-api.googleapis.com`

BigQuery API - `bigquery.googleapis.com`

Cloud Pub/Sub API - `pubsub.googleapis.com`

## Note

-  Using a unique writer identity is strongly advised when creating new sinks. For better security, use a unique writer for all new sinks.

### Reference

- https://github.com/terraform-google-modules/terraform-google-log-export