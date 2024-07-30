resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = var.location
  project     = var.project_id
  service     = var.service_name
  policy_data = data.google_iam_policy.noauth.policy_data
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}