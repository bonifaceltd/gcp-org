resource "google_compute_ha_vpn_gateway" "this" {
  name    = var.name
  project = google_project.env.project_id
  network = module.vpc.network_name
}

resource "google_compute_router" "this" {
  name    = var.name
  project = google_project.env.project_id
  network = module.vpc.network_name
  bgp {
    asn               = "645${var.asn}"
    advertise_mode    = "CUSTOM"
    advertised_groups = []

    advertised_ip_ranges {
      range = var.cidr_range
    }
  }
}

resource "google_compute_vpn_tunnel" "transport" {
  count                 = 2
  name                  = "${var.name}-tun${count.index}"
  project               = lookup(var.transport, "project", "")
  vpn_gateway           = lookup(var.transport, "gw", "")
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.this.self_link
  shared_secret         = "secret"
  router                = lookup(var.transport, "cr_link", "")
  vpn_gateway_interface = count.index
}

resource "google_compute_vpn_tunnel" "squad" {
  count                 = 2
  name                  = "transport-${local.env}-tun${count.index}"
  project               = google_project.env.project_id
  vpn_gateway           = google_compute_ha_vpn_gateway.this.id
  peer_gcp_gateway      = lookup(var.transport, "gw", "")
  shared_secret         = "secret"
  router                = google_compute_router.this.id
  vpn_gateway_interface = count.index
}

resource "google_compute_router_interface" "transport" {
  count      = 2
  name       = "${var.name}-iface${count.index}"
  project    = lookup(var.transport, "project", "")
  router     = lookup(var.transport, "cr_name", "")
  ip_range   = "${cidrhost(local.tunnel_ip_range[count.index], 1)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.transport[count.index].name
}

resource "google_compute_router_peer" "squad_transport" {
  count                     = 2
  name                      = "peer-transport-${local.env}-iface${count.index}"
  project                   = google_project.env.project_id
  router                    = google_compute_router.this.name
  peer_ip_address           = cidrhost(local.tunnel_ip_range[count.index], 1)
  peer_asn                  = lookup(var.transport, "asn", "")
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.transport[count.index].name
}

resource "google_compute_router_interface" "squad" {
  count      = 2
  name       = "transport-${local.env}-iface${count.index}"
  project    = google_project.env.project_id
  router     = google_compute_router.this.name
  ip_range   = "${cidrhost(local.tunnel_ip_range[count.index], 2)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.squad[count.index].name
}

resource "google_compute_router_peer" "transport_squad" {
  count                     = 2
  name                      = "peer-${var.name}-iface${count.index}"
  project                   = lookup(var.transport, "project", "")
  router                    = lookup(var.transport, "cr_name", "")
  peer_ip_address           = cidrhost(local.tunnel_ip_range[count.index], 2)
  peer_asn                  = "645${var.asn}"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.squad[count.index].name
}
