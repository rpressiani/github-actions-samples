variable "project_id" {
  type        = string
  description = "The Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "The Google Cloud Region"
  default     = "us-central1"
}

variable "gh_org" {
  type        = string
  description = "GitHub organization"
}

variable "gh_repo" {
  type        = string
  description = "GitHub repository"
}
