resource "google_service_account" "app_sa" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project_id
}

resource "google_project_iam_member" "sa_role" {
  project = var.project_id
  role    = var.role
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}
