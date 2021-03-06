variable "teamid" {
  description = "Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
}

variable "prjid" {
  description = "Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
}

variable "sink_name" {
  description = "Google storage bucket name"
  default     = null
  type        = string
}

variable "deploy_project_sink" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}
/*
variable "deploy_org_sink" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}

variable "deploy_bucket" {
  description = "Feature flag, true or false"
  default     = true
  type        = bool
}
*/
variable "bucket_name" {
  description = "Google storage bucket name"
  default     = null
  type        = string
}

variable "unique_writer_identity" {
  description = "Whether or not to create a unique identity associated with this sink. If false (the default), then the writer_identity used is serviceAccount:cloud-logs@system.gserviceaccount.com. If true, then a unique service account is created and used for the logging sink."
  type        = bool
  default     = false
}
/*
variable "parent_resource_type" {
  description = "The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'."
  type        = string
  default     = "project"
}

variable "parent_resource_id" {
  description = "The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc)."
  default     = null
  type        = string
}

variable "message_storage_policy" {
  type        = map(any)
  description = "A map of storage policies. Default - inherit from organization's Resource Location Restriction policy."
  default     = {}
}

variable "topic_kms_key_name" {
  description = "The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic."
  default     = null
  type        = string
}
*/
variable "topic_name" {
  default     = null
  description = "The Pub/Sub topic name"
  type        = string
}
/*
variable "create_topic" {
  type        = bool
  description = "Specify true if you want to create a topic"
  default     = true
}
*/
variable "exclusions" {
  description = "Exclusions"
  default     = []
  type = set(object({
    name        = string
    description = string
    filter      = string
  }))
}

# TODO: move to list format
variable "inclusion_filter" {
  description = "Inclusion filter"
  type        = string
  default     = ""
}

variable "bigquery_options" {
  default     = null
  description = "(Optional) Options that affect sinks exporting data to BigQuery. use_partitioned_tables - Whether to use BigQuery's partition tables."
  type = object({
    use_partitioned_tables = bool
  })
}

variable "existing_topic_name" {
  description = "Existing PubSub name"
  default     = null
  type        = string
}
