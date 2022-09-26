terraform {
  backend "gcs" {
    bucket = "ddoc-sandbox-project-envs-tfstate"
    prefix = "qa"
  }
}