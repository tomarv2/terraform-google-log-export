locals {
  is_project_level = var.parent_resource_type == "project"
  is_folder_level  = var.parent_resource_type == "folder"
  is_org_level     = var.parent_resource_type == "organization"
  is_billing_level = var.parent_resource_type == "billing_account"

  existing_topic_name = var.existing_topic_name != null ? "pubsub.googleapis.com/${var.existing_topic_name}" : "pubsub.googleapis.com/projects/${var.gcp_project}/topics/${local.topic_name}"

  destination = var.bucket_name != null ? "storage.googleapis.com/${var.bucket_name}" : local.existing_topic_name

  # Bigquery sink options
  bigquery_options = var.bigquery_options == null ? [] : var.unique_writer_identity == true ? list(var.bigquery_options) : []

  # PubSub
  create_topic = var.bucket_name != null ? false : true
  topic_name   = var.topic_name != null ? var.topic_name : "${var.teamid}-${var.prjid}"

}
