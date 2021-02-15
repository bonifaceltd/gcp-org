variable "asn" { type = string }
variable "cidr_range" { type = string }
variable "parent" { type = string }
variable "org" { type = string }
variable "name" { type = string }
variable "subnets" { type = list(map(string)) }
variable "transport" { type = map(string) }

locals {
  envs = list("dev", "stg", "prd")
  env  = join("", matchkeys(local.envs, local.envs, split("-", var.name)))

  tunnel_ip_range = [
    cidrsubnet("169.254.${var.asn}.0/29", 1, 0),
    cidrsubnet("169.254.${var.asn}.0/29", 1, 1)
  ]
}
