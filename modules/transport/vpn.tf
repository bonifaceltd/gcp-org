resource "google_compute_ha_vpn_gateway" "this" {
  name     = var.name
  project  = google_project.env.project_id
  network  = module.vpc.network_name
}

resource "google_compute_router" "this" {
  name     = var.name
  project  = google_project.env.project_id
  network  = module.vpc.network_name
  bgp {
    asn = "645${var.asn}"
    advertise_mode = "CUSTOM"
    advertised_groups = []

    advertised_ip_ranges {
      range = var.cidr_range
    }
  }
}
