# Terraform State Storage
# terraform {
#   backend "gcs" {
#     bucket = "osp-dev-gcs-tfstate"
#     prefix = "cloud/osp-dev-cloud-resources"
#   }
# }

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.2.2"

  project_id   = var.project_id
  names        = ["${local.sa_naming_standard}-kms-main"]
  display_name = "${local.sa_naming_standard}-kms-main"
  description  = "Service Account for ${local.sa_naming_standard}-kms-main"
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.2.3"

  project_id          = var.project_id
  location            = "global"
  keyring             = "${local.kms_naming_standard}-keyring-main"
  key_rotation_period = "2592000s"
  # key_destroy_scheduled_duration = "86400s"
  purpose              = "ENCRYPT_DECRYPT"
  key_algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
  key_protection_level = "SOFTWARE"
  keys                 = ["${local.kms_naming_standard}-cryptokey-main"]
  encrypters           = [module.service_accounts.iam_email]
  decrypters           = [module.service_accounts.iam_email]
  set_encrypters_for   = ["${local.kms_naming_standard}-cryptokey-main"]
  set_decrypters_for   = ["${local.kms_naming_standard}-cryptokey-main"]
  set_owners_for       = ["${local.kms_naming_standard}-cryptokey-main"]
  owners = [
    "user:imam.arief.rhmn@gmail.com,serviceAccount:osp-dev@osp-dev-405908.iam.gserviceaccount.com"
  ]

  prevent_destroy = true
}

module "gcs_tfstate" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 5.0"

  project_id      = var.project_id
  location        = var.region
  names           = ["${local.gcs_naming_standard}-tfstate"]
  set_admin_roles = true
  force_destroy = {
    "${local.gcs_naming_standard}-tfstate" = true
  }
  admins = ["user:imam.arief.rhmn@gmail.com", "serviceAccount:osp-dev@osp-dev-405908.iam.gserviceaccount.com"]
  versioning = {
    "${local.gcs_naming_standard}=tfstate" = true
  }
  bucket_admins = {
    second = "user:imam.arief.rhmn@gmail.com,serviceAccount:osp-dev@osp-dev-405908.iam.gserviceaccount.com"
  }
}
