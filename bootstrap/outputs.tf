output "sa_email" {
  value = google_service_account.gh_actions.email
}

output "oidc_provider_name" {
  value = module.gh_oidc.provider_name
}
