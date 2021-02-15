dependencies {
  paths = ["../folder"]
}

dependency "transport_folder" {
  config_path                             = "../folder"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    id = "folders/123456"
  }
}

terraform {
  source = "../..//modules/transport"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  parent     = dependency.transport_folder.outputs.id
  org        = "bon"
  name       = "transport-prd"
  subnets    = []
  asn        = 13
  cidr_range = "10.0.8.0/22"
}