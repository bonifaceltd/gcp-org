module "bootstrap" {
  source  = "terraform-google-modules/bootstrap/google"
  version = "~> 2.1"

  org_id               = "1077773425109"
  project_id           = "${local.org}-terraform-007"
  project_prefix       = local.org
  billing_account      = "01C4CA-74671D-650411"
  group_org_admins     = "org-admins@${var.org}"
  group_billing_admins = "billing-admins@${var.org}"
  state_bucket_name    = "${local.org}-terraform-state"

  sa_enable_impersonation = true
}

locals {
  org = substr(var.org, 0, 3)
}