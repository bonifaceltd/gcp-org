resource "google_project" "env" {
  name                = "${var.org}-${var.name}"
  project_id          = "${var.org}-${var.name}-007"
  folder_id           = google_folder.env.name
  billing_account     = "01C4CA-74671D-650411"
  auto_create_network = false
}

resource "google_project_service" "api" {
  for_each = toset(["compute", "serviceusage", "iam", "iamcredentials", "cloudresourcemanager", "dns", "cloudbilling", "storage-api", "logging", "stackdriver", "monitoring"])
  project = google_project.env.project_id
  service = "${each.value}.googleapis.com"
}
