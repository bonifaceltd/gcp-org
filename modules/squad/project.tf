resource "google_project" "env" {
  name                = "${var.org}-${var.name}"
  project_id          = "${var.org}-${var.name}-07"
  folder_id           = google_folder.env.name
  billing_account     = local.billing_account[local.env]
  auto_create_network = false
}

resource "google_project_service" "api" {
  for_each = toset(["compute", "serviceusage", "iam", "iamcredentials", "cloudresourcemanager", "dns", "cloudbilling", "storage-api", "logging", "stackdriver", "monitoring"])
  project  = google_project.env.project_id
  service  = "${each.value}.googleapis.com"

  disable_on_destroy = false
}
