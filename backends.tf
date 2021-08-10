# --- root/providers.tf

terraform {
  backend "remote" {
    organization = "stefiix"

    workspaces {
      name = "sonarqube-dev"
    }
  }
}