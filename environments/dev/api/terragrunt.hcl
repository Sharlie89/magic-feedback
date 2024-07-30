terraform {
  source = "../../gcp/profiles/infra-api"
}

inputs = {
  project_id   = "dev-project-id"
  region       = "us-central1"
  service_name = "dev-service-name"
  image        = "us-central1-docker.pkg.dev/dev-project-id/docker-repo/image:tag"
}