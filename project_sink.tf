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
  destination = local.destination
  #----------------------------------------------
  # INCLUSION
  #----------------------------------------------
  filter = var.inclusion_filter
  #----------------------------------------------
  # EXCLUSION
  #----------------------------------------------
  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      name        = exclusions.value["name"]
      description = exclusions.value["description"]
      filter      = exclusions.value["filter"]
    }
  }
  #----------------------------------------------
  # BIG QUERY
  #----------------------------------------------
  dynamic "bigquery_options" {
    for_each = local.bigquery_options
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }
}