locals {
  region = var.region
  tags = {
    GithubRepo = var.github_repo
    GithubOrg  = var.github_owner
  }

  # vpc_cidr     = "10.0.0.0/16"
  # rfc6598_cidr = "100.64.0.0/16"
  # SA
  sa_standard = {
    Unit    = var.unit
    Env     = var.env
    Code    = "iam"
    Feature = "sa"
  }
  sa_naming_standard = "${local.sa_standard.Unit}-${local.sa_standard.Env}-${local.sa_standard.Code}-${local.sa_standard.Feature}"
  # KMS
  kms_standard = {
    Unit = var.unit
    Env  = var.env
    Code = "kms"
  }
  kms_naming_standard = "${local.kms_standard.Unit}-${local.kms_standard.Env}-${local.kms_standard.Code}"
  # GCS
  gcs_standard = {
    Unit    = var.unit
    Env     = var.env
    Code    = "gcs"
  }
  gcs_naming_standard = "${local.gcs_standard.Unit}-${local.gcs_standard.Env}-${local.gcs_standard.Code}"
}
