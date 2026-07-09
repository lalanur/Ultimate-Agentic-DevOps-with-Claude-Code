---
name: terraform-version-mismatch
description: providers.tf allows Terraform >=1.5 but backend.tf's commented S3 backend example uses use_lockfile, which requires Terraform >=1.10 — a version floor inconsistency to flag.
metadata:
  type: project
---

`terraform/providers.tf` sets `required_version = ">= 1.5"`, but `terraform/backend.tf` documents (in a commented-out example block) an S3 backend using `use_lockfile = true` for state locking — a feature that requires Terraform >=1.10. If someone on Terraform 1.5–1.9 uncomments and uses that backend block, state locking silently won't work, risking concurrent-apply state corruption.

**Why:** Not obvious from reading either file in isolation — only surfaces when cross-referencing the version constraint against the specific backend feature being relied on.

**How to apply:** When reviewing backend.tf or providers.tf changes, check that `required_version` is bumped to `>= 1.10` if `use_lockfile` is (or becomes) active, or recommend a DynamoDB lock table instead if supporting older Terraform versions is required.
