variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "location" {
  description = "The GCP location"
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
}