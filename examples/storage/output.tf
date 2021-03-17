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

output "project_sink_writer_identity" {
  description = "Project log sink write identity"
  value       = module.project_sink.project_sink_writer_identity
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
