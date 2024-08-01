provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source  = "../../modules/vpc"
  region  = var.region
}

module "iam" {
  source      = "../../modules/iam"
  project_id  = var.project_id
  location    = var.region
  service_name = google_cloud_run_service.service.name
}

resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
