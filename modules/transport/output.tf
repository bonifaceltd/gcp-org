output "vpn" {
  value = {
    project = google_project.env.project_id
    asn     = "645${var.asn}"
    gw      = google_compute_ha_vpn_gateway.this.self_link
    cr_name = google_compute_router.this.name
    cr_link = google_compute_router.this.self_link
  }
}
