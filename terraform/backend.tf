# Remote state backend (S3)
#
# The backend is intentionally commented out for the FIRST run so you can
# bootstrap the state bucket with local state:
#
#   1. Run `terraform init` (no backend — uses local state).
#   2. Run `terraform apply` to create the resources, including a bucket
#      you designate for remote state (create it manually or add an
#      aws_s3_bucket resource for it).
#   3. Uncomment the block below and set your state bucket name/key.
#   4. Run `terraform init -migrate-state` to move local state into S3.
#
# terraform {
#   backend "s3" {
#     bucket       = "portfolio-site-tfstate"   # your state bucket name
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true                        # S3-native state locking (Terraform >= 1.10)
#   }
# }
