provider "google" {
  project = var.project_id
  region  = var.region
}

module "artifact_registry" {
  source     = "../../../gcp/modules/artifact-registry"
  project_id = var.project_id
  region     = var.region
  repository_name = var.registry_name
}
