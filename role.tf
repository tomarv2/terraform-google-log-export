# NOTE: For sink with unique_writer:
# grant ""roles/storage.objectCreator"(writer) access to the bucket
#-----------------------------------------------
//resource "google_project_iam_binding" "log-writer" {
//  role = "roles/storage.objectCreator"
//
//  members = [
//    google_logging_project_sink.instance-sink.writer_identity,
//  ]
//}