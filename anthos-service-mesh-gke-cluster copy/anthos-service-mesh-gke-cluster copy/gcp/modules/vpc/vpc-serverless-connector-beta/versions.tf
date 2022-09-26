terraform {
  required_version = ">= 0.13.0"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.62"
    }
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-network:vpc-serverless-connector-beta/v5.0.0"
  }
}
