terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.53, < 5.0"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-sql-db:private_service_access/v12.0.0"
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-sql-db:private_service_access/v12.0.0"
  }

}