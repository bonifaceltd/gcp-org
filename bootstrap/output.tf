output "bucket" {
  value = module.bootstrap.gcs_bucket_tfstate
}

output "project" {
  value = module.bootstrap.seed_project_id
}

output "svc_account" {
  value = module.bootstrap.terraform_sa_email
}