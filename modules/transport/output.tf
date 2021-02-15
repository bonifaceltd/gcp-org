output "vpn" {
    value = {
        project = google_project.env.project_id
        asn     = var.asn
        gw      = google_compute_ha_vpn_gateway.this.name
        cr      = google_compute_router.this
    }
}
