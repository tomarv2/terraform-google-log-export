output "project_sink_name" {
  description = "Project log sink name"
  value       = module.project_log_export.project_sink_name
}

output "project_sink_destination" {
  description = "Project log sink destination"
  value       = module.project_log_export.project_sink_destination
}

output "project_sink_unique_writer_identity" {
  description = "Project log sink write identity"
  value       = module.project_log_export.project_sink_unique_writer_identity
}

output "project_sink_writer_identity" {
  description = "Project log sink write identity"
  value       = module.project_log_export.project_sink_writer_identity
}

output "project_sink_project" {
  description = "Project log sink project"
  value       = module.project_log_export.project_sink_project
}

output "project_sink_topic_name" {
  description = "Project log topic name"
  value       = module.pubsub.pubsub_topic_name
}

output "pubsub_subscription_name" {
  description = "PubSub subscription name"
  value       = module.pubsub.pubsub_subscription_name
}

output "pubsub_subscription_topic" {
  description = "PubSub subscription topic"
  value       = module.pubsub.pubsub_subscription_topic
}

output "pubsub_message_retention" {
  description = "PubSub subscription retention"
  value       = module.pubsub.pubsub_message_retention
}
output "pubsub_subscription_id" {
  description = "PubSub subscription id"
  value       = module.pubsub.pubsub_subscription_id
}
