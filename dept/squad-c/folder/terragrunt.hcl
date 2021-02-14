terraform {
  source = "../../..//modules/folder"
}

dependencies {
  paths = ["../../folder"]
}

dependency "dept-folder" {
  config_path                             = "../../folder"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    id = "folders/123456"
  }
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name   = "squad-c"
  parent = dependency.dept-folder.outputs.id
}