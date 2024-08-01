terraform {
  source = "../../..//gcp/profiles/infra-api"
}

inputs = {
  project_id   = "prod-project-id"
  region       = "us-central1"
  service_name = "prod-service-name"
  image        = "us-central1-docker.pkg.dev/prod-project-id/docker-repo/image:tag"
}
