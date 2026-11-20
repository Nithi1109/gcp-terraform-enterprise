output "service_account_email" {
  description = "Created service account email"
  value       = google_service_account.app_sa.email
}
