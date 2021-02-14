resource "google_folder" "env" {
  display_name = local.env
  parent       = var.parent
}

resource "google_folder" "projects" {
  display_name = "projects"
  parent       = google_folder.env.name
}
