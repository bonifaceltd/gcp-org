output "vpn" {
  value = {
    project = google_project.env.project_id
    asn     = "645${var.asn}"
    gw      = google_compute_ha_vpn_gateway.this.self_link
    cr      = google_compute_router.this.self_link
  }
}
