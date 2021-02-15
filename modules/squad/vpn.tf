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

resource "google_compute_vpn_tunnel" "transport0" {
  name                  = "${var.name}-tun0"
  project               = var.transport["project"]
  vpn_gateway           = var.transport["gw"]
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.this.id
  shared_secret         = "secret"
  router                = var.transport["cr"]
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "transport1" {
  name                  = "${var.name}-tun1"
  project               = var.transport["project"]
  vpn_gateway           = var.transport["gw"]
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.this.id
  shared_secret         = "secret"
  router                = var.transport["cr"]
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "squad0" {
  name                  = "transport-${local.env}-tun0"
  project               = google_project.env.project_id
  vpn_gateway           = google_compute_ha_vpn_gateway.this.id
  peer_gcp_gateway      = var.transport["gw"]
  shared_secret         = "secret"
  router                = google_compute_router.this.id
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "squad1" {
  name                  = "transport-${local.env}-tun1"
  project               = google_project.env.project_id
  vpn_gateway           = google_compute_ha_vpn_gateway.this.id
  peer_gcp_gateway      = var.transport["gw"]
  shared_secret         = "secret"
  router                = google_compute_router.this.id
  vpn_gateway_interface = 0
}

resource "google_compute_router_interface" "transport0" {
  name       = "${var.name}-iface0"
  project    = var.transport["project"]
  router     = var.transport["cr"]
  ip_range   = "${cidrhost(local.tunnel_ip_range[0], 1)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.transport0.name
}

resource "google_compute_router_peer" "squad_transport0" {
  name                      = "peer-transport-${local.env}-iface0"
  project                   = google_project.env.project_id
  router                    = google_compute_router.this.id
  peer_ip_address           = cidrhost(local.tunnel_ip_range[0], 2)
  peer_asn                  = "645${var.asn}"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.transport0.name
}

resource "google_compute_router_interface" "transport1" {
  name       = "${var.name}-iface1"
  project    = var.transport["project"]
  router     = var.transport["cr"]
  ip_range   = "${cidrhost(local.tunnel_ip_range[1], 1)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.transport1.name
}

resource "google_compute_router_peer" "squad_transport1" {
  name                      = "peer-transport-${local.env}-iface1"
  project                   = google_project.env.project_id
  router                    = google_compute_router.this.id
  peer_ip_address           = cidrhost(local.tunnel_ip_range[1], 2)
  peer_asn                  = "645${var.asn}"
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.transport1.name
}

resource "google_compute_router_interface" "squad0" {
  name       = "transport-${local.env}-iface0"
  project    = google_project.env.project_id
  router     = google_compute_router.this.id
  ip_range   = "${cidrhost(local.tunnel_ip_range[0], 2)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.squad0.name
}

resource "google_compute_router_peer" "transport_squad0" {
  name                      = "peer-${var.name}-iface0"
  project                   = var.transport["project"]
  router                    = var.transport["cr"]
  peer_ip_address           = cidrhost(local.tunnel_ip_range[0], 1)
  peer_asn                  = var.transport["asn"]
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.squad0.name
}

resource "google_compute_router_interface" "squad1" {
  name       = "transport-${local.env}-iface1"
  project    = google_project.env.project_id
  router     = google_compute_router.this.id
  ip_range   = "${cidrhost(local.tunnel_ip_range[1], 2)}/30"
  vpn_tunnel = google_compute_vpn_tunnel.squad1.name
}

resource "google_compute_router_peer" "transport_squad1" {
  name                      = "peer-${var.name}-iface1"
  project                   = var.transport["project"]
  router                    = var.transport["cr"]
  peer_ip_address           = cidrhost(local.tunnel_ip_range[1], 1)
  peer_asn                  = var.transport["asn"]
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.squad1.name
}