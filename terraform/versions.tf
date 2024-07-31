terraform {
  backend "gcs" {
    bucket = "gh-actions-tfstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
