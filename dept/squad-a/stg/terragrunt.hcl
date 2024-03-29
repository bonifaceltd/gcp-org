locals {
  env   = "stg"
  squad = "squad-a"
}

dependencies {
  paths = ["../folder", "../../../transport/${local.env}"]
}

dependency "squad_folder" {
  config_path                             = "../folder"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    id = "folders/123456"
  }
}

dependency "transport" {
  config_path                             = "../../../transport/${local.env}"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpn = {}
  }
}

terraform {
  source = "../../..//modules/squad"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  parent     = dependency.squad_folder.outputs.id
  org        = "bon"
  name       = "dept-${local.squad}-${local.env}"
  subnets    = []
  asn        = 23
  cidr_range = "10.0.5.0/24"
  transport  = dependency.transport.outputs.vpn
}