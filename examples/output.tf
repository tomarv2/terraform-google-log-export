output "project_sink_name" {
  description = "Project log sink name"
  value       = module.project_sink.project_sink_name
}

output "project_sink_destination" {
  description = "Project log sink destination"
  value       = module.project_sink.project_sink_destination
}

output "project_sink_unique_writer_identity" {
  description = "Project log sink write identity"
  value       = module.project_sink.project_sink_unique_writer_identity
}

output "project_sink_writer_identfity" {
  description = "Project log sink write identity"
  value       = module.project_sink.project_sink_writer_identfity
}

output "project_sink_project" {
  description = "Project log sink project"
  value       = module.project_sink.project_sink_project
}

output "storage_bucket_name" {
  description = "Storage bucket name"
  value       = module.storage_bucket.storage_bucket_name
}

output "storage_bucket_url" {
  description = "Storage bucket url"
  value       = module.storage_bucket.storage_bucket_url
}

output "storage_bucket_class" {
  description = "Storage bucket class"
  value       = module.storage_bucket.storage_bucket_storage_class
}

output "storage_bucket_location" {
  description = "Storage bucket location"
  value       = module.storage_bucket.storage_bucket_location
}

output "project_sink_topic_name" {
  description = "Project log topic name"
  value       = module.pubsub.pubsub_topic_name
}

//output "project_sink_kms_key_name" {
//  description = "Project log kms key name"
//  value       = module.pubsub.pubsub_topic_kms_key_name
//}

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