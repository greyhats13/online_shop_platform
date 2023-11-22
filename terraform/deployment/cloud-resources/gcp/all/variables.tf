# Naming Standard
variable "region" {
  type        = string
  description = "The GCP region where resources will be created."
}

variable "unit" {
  type        = string
  description = "Business unit code."
}

variable "env" {
  type        = string
  description = "Stage environment where the infrastructure will be deployed."
}

variable "project_id" {
  type        = string
  description = "The GCP Project ID"
}

# Github
variable "github_repo" {
  type        = string
  description = "Github Repository name"
}

variable "github_owner" {
  type        = string
  description = "Github Repository owner"
}
