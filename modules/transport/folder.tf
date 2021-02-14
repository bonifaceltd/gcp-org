resource "google_folder" "env" {
  display_name = local.env
  parent       = var.parent
}
