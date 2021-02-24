terraform {
  source = "../..//modules/folder"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name   = "demo"
  parent = "organizations/1077773425109"
}