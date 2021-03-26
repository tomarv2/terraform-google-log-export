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

