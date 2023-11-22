# Terraform State Storage
# terraform {
#   backend "gcs" {
#     bucket = "osp-dev-gcs-tfstate"
#     prefix = "cloud/osp-dev-cloud-resources"
#   }
# }

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 4.2.2"

  project_id    = var.project_id
  names         = ["${local.sa_naming_standard}-kms-main"]
  display_name  = "${local.sa_naming_standard}-kms-main"
  description   = "Service Account for ${local.sa_naming_standard}-kms-main"
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.2.3"

  project_id                     = var.project_id
  location                       = "global"
  keyring                        = "${local.kms_naming_standard}-keyring-main"
  key_rotation_period            = "2592000s"
  # key_destroy_scheduled_duration = "86400s"
  purpose                        = "ENCRYPT_DECRYPT"
  key_algorithm                  = "GOOGLE_SYMMETRIC_ENCRYPTION"
  key_protection_level           = "SOFTWARE"
  keys                           = ["${local.kms_naming_standard}-cryptokey-main"]
  prevent_destroy                = true

}
