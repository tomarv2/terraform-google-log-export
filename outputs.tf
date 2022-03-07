output "project_sink_name" {
  description = "Project log sink name"
  value       = join("", google_logging_project_sink.default.*.name)
}

output "project_sink_destination" {
  description = "Project log sink destination"
  value       = join("", google_logging_project_sink.default.*.destination)
}

output "project_sink_unique_writer_identity" {
  description = "Project log sink write identity"
  value       = join("", google_logging_project_sink.default.*.unique_writer_identity)
}

output "project_sink_writer_identity" {
  description = "Project log sink write identity"
  value       = join("", google_logging_project_sink.default.*.writer_identity)
}

output "project_sink_project" {
  description = "Project log sink project"
  value       = join("", google_logging_project_sink.default.*.project)
}
