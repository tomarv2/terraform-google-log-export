resource "google_logging_project_sink" "default" {
  count = var.deploy_project_sink ? 1 : 0

  name = var.sink_name != null ? var.sink_name : "${var.teamid}-${var.prjid}"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = var.unique_writer_identity
  #----------------------------------------------
  # Options to export logs to:
  # - PubSub
  # - Cloud Storage
  # - BigQuery
  #----------------------------------------------
  destination = "pubsub.googleapis.com/projects/${var.gcp_project}/topics/${local.topic_name}" #local.destination
  #----------------------------------------------
  # BIG QUERY
  #----------------------------------------------
  dynamic "bigquery_options" {
    for_each = local.bigquery_options
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }
  #----------------------------------------------
  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type = gce_instance AND severity >= WARNING"
  #----------------------------------------------
  # EXCLUSION
  #----------------------------------------------
  exclusions {
    name        = "nsexcllusion1"
    description = "Exclude logs from namespace-1 in k8s"
    filter      = "resource.type = k8s_container resource.labels.namespace_name=\"namespace-1\" "
  }

  exclusions {
    name        = "nsexcllusion2"
    description = "Exclude logs from namespace-2 in k8s"
    filter      = "resource.type = k8s_container resource.labels.namespace_name=\"namespace-2\" "
  }
}