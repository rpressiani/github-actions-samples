module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 15.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ]
}

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = "example-pool"
  provider_id = "example-gh-provider"
  sa_mapping = {
    "${google_service_account.gh_actions.account_id}" = {
      sa_name   = google_service_account.gh_actions.id
      attribute = "attribute.repository/${var.gh_org}/${var.gh_repo}"
    }
  }
}

resource "google_service_account" "gh_actions" {
  account_id = "gh-actions"
}

resource "google_project_iam_member" "gh_actions_roles" {
  for_each = toset([
    "roles/serviceusage.serviceUsageConsumer",
    "roles/iam.serviceAccountAdmin",
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_storage_bucket" "gh_actions_tfstate" {
  name     = "gh-actions-tfstate"
  location = var.region
  force_destroy = false
}

resource "google_storage_bucket_iam_member" "gh_actions_tfstate_roles" {
  bucket = google_storage_bucket.gh_actions_tfstate.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gh_actions.email}"
}
