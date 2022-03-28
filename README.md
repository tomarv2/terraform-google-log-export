<p align="center">
    <a href="https://github.com/tomarv2/terraform-google-project-sink/actions/workflows/pre-commit.yml" alt="Pre Commit">
        <img src="https://github.com/tomarv2/terraform-google-project-sink/actions/workflows/pre-commit.yml/badge.svg?branch=main" /></a>
    <a href="https://www.apache.org/licenses/LICENSE-2.0" alt="license">
        <img src="https://img.shields.io/github/license/tomarv2/terraform-google-project-sink" /></a>
    <a href="https://github.com/tomarv2/terraform-google-project-sink/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-project-sink" /></a>
    <a href="https://github.com/tomarv2/terraform-google-project-sink/pulse" alt="Activity">
        <img src="https://img.shields.io/github/commit-activity/m/tomarv2/terraform-google-project-sink" /></a>
    <a href="https://stackoverflow.com/users/6679867/tomarv2" alt="Stack Exchange reputation">
        <img src="https://img.shields.io/stackexchange/stackoverflow/r/6679867"></a>
    <a href="https://twitter.com/intent/follow?screen_name=varuntomar2019" alt="follow on Twitter">
        <img src="https://img.shields.io/twitter/follow/varuntomar2019?style=social&logo=twitter"></a>
</p>

## Terraform module for Google Cloud log export

**There are four levels of log exports for Google cloud:**

:point_right: project level

:point_right: folder level

:point_right: organization level

:point_right: billing_account level

**NOTE:** Plan correctly as there is cost associated with log export.

### Versions

- Module tested for Terraform 1.0.1.
- Google provider version [4.12.0](https://registry.terraform.io/providers/hashicorp/google/latest)
- `main` branch: Provider versions not pinned to keep up with Terraform releases
- `tags` releases: Tags are pinned with versions (use <a href="https://github.com/tomarv2/terraform-google-project-sink/tags" alt="GitHub tag">
        <img src="https://img.shields.io/github/v/tag/tomarv2/terraform-google-project-sink" /></a> in your releases)

### Usage

#### Option 1:

```
terrafrom init
terraform plan -var='teamid=tryme' -var='prjid=project1'
terraform apply -var='teamid=tryme' -var='prjid=project1'
terraform destroy -var='teamid=tryme' -var='prjid=project1'
```
**Note:** With this option please take care of remote state storage

#### Option 2:

##### Recommended method (stores remote state in S3 using `prjid` and `teamid` to create directory structure):

- Create python 3.8+ virtual environment
```
python3 -m venv <venv name>
```

- Install package:
```
pip install tfremote --upgrade
```

- Set below environment variables:
```
export TF_GCLOUD_BUCKET=<remote state bucket name>
export TF_GCLOUD_PREFIX=<remote state bucket prefix>
export TF_GCLOUD_CREDENTIALS=<gcp credentials.json>
```

- Updated `examples` directory with required values.

- Run and verify the output before deploying:
```
tf -c=gcloud plan -var='teamid=foo' -var='prjid=bar'
```

- Run below to deploy:
```
tf -c=gcloud apply -var='teamid=foo' -var='prjid=bar'
```

- Run below to destroy:
```
tf -c=gcloud destroy -var='teamid=foo' -var='prjid=bar'
```

**Note:** Read more on [tfremote](https://github.com/tomarv2/tfremote)
##### Project Log Export to new PubSub topic (pull method)
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

## Permissions

**Service account with the following roles is required:**

- On the logsink's project, folder, or organization (to create the logsink) enable:

:point_right: `roles/logging.configWriter`

- On the destination project (to grant write permissions for logsink service account) enable:

:point_right: `roles/resourcemanager.projectIamAdmin`

- On the destination project (to enable destination APIs) enable:

:point_right: `roles/serviceusage.serviceUsageAdmin`

**Pub/Sub roles**

To use a Google Cloud Pub/Sub topic as the destination, on the destination project (to create a pub/sub topic):

:point_right: `roles/pubsub.admin`

**Storage role**

To use a Google Cloud Storage bucket as the destination, on the destination project (to create a storage bucket):

:point_right: `roles/storage.admin`

**BigQuery role**

To use a BigQuery dataset as the destination, on the destination project (to create a BigQuery dataset):

:point_right: `roles/bigquery.dataEditor`

## Project APIs

**Following APIs must be enabled on the project:**

:point_right: Cloud Resource Manager API - `cloudresourcemanager.googleapis.com`

:point_right: Cloud Billing API - `cloudbilling.googleapis.com`

:point_right: Identity and Access Management API - `iam.googleapis.com`

:point_right: Service Usage API - `serviceusage.googleapis.com`

:point_right: Stackdriver Logging API - `logging.googleapis.com`

:point_right: Cloud Storage JSON API - `storage-api.googleapis.com`

:point_right: BigQuery API - `bigquery.googleapis.com`

:point_right: Cloud Pub/Sub API - `pubsub.googleapis.com`

## Note

-  Using a unique writer identity is strongly advised when creating new sinks. For better security, use a unique writer for all new sinks.

### Reference

- https://github.com/terraform-google-modules/terraform-google-log-export

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->