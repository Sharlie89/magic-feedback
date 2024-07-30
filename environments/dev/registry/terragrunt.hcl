terraform {
  source = "../../../gcp/profiles/artifact-registry"
}

inputs = {
  project_id     = "dev-project-id"
  region         = "us-central1"
  registry_name = "registry-name"
}
