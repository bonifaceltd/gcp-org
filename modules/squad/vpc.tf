module "vpc" {
  source = "terraform-google-modules/network/google"

  project_id   = google_project.env.project_id
  network_name = var.name
  routing_mode = "GLOBAL"
  subnets      = var.subnets

  shared_vpc_host = true
}