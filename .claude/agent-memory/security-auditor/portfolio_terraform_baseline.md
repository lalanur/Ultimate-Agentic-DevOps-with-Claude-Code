---
name: portfolio-terraform-baseline
description: Security controls already correctly implemented in terraform/main.tf for the portfolio site (S3+CloudFront) — use as a baseline to detect drift/regressions in future audits.
metadata:
  type: project
---

As of the 2026-07-09 audit, terraform/main.tf in this repo (S3 + CloudFront static site) already correctly implements:
- `aws_s3_bucket_public_access_block` with all four flags set to true (blocks public ACLs/policy).
- `aws_s3_bucket_ownership_controls` set to `BucketOwnerEnforced` (disables ACLs entirely — good, modern pattern).
- CloudFront uses Origin Access Control (OAC), not the legacy OAI — `aws_cloudfront_origin_access_control` with `signing_behavior = "always"`.
- S3 bucket policy scoped via `AWS:SourceArn` condition to the specific CloudFront distribution ARN (not a blanket service-principal allow).
- `aws_s3_bucket_policy` has `depends_on` the public access block, avoiding a race where the policy could apply before public access is blocked.
- `viewer_protocol_policy = "redirect-to-https"` on the default cache behavior (HTTP→HTTPS redirect present).
- No hardcoded secrets, ARNs, or account IDs anywhere in the five terraform/*.tf files — everything is via `var.*`, `data.*`, or resource references.

**Why:** Future audits should not re-flag these as findings; they represent a deliberate, already-hardened baseline. Compare new terraform diffs against this list to catch regressions (e.g., someone switching back to OAI, or removing the SourceArn condition).

**How to apply:** When re-auditing terraform/main.tf, confirm these controls are still present before spending time re-verifying them from scratch. See [[portfolio-terraform-gaps]] for what's still missing.
