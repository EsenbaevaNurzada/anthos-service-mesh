resource "google_service_account" "account" {
  project = var.project
  account_id = var.account_id
  display_name = var.account_name
}

resource "google_project_iam_member" "account_iam" {
  project = var.project
  role = var.role
  member = "serviceAccount:${google_service_account.account.email}"
}