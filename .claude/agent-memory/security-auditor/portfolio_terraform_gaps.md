---
name: portfolio-terraform-gaps
description: Security gaps repeatedly found missing in terraform/ for the portfolio site (S3+CloudFront) — check these first in future audits since they have not yet been remediated.
metadata:
  type: project
---

As of the 2026-07-09 audit, the following are absent from terraform/*.tf (confirmed via grep for the relevant resource types, zero matches):
- No `aws_s3_bucket_versioning` resource — no protection against accidental overwrite/delete of site content or state-adjacent recovery.
- No `aws_s3_bucket_server_side_encryption_configuration` — relies entirely on AWS's default-since-2023 SSE-S3, nothing explicit/auditable in code.
- No CloudFront `logging_config` block — zero access-log visibility into requests hitting the distribution.
- No S3 `aws_s3_bucket_logging` — no audit trail for direct S3 API access.
- No `response_headers_policy_id` on the default cache behavior — no CSP, X-Frame-Options, X-Content-Type-Options, Strict-Transport-Security headers served.
- No `aws_wafv2_web_acl` associated with the CloudFront distribution.
- No IAM or OIDC trust-policy terraform files exist yet in `terraform/` (only providers.tf, variables.tf, main.tf, outputs.tf, backend.tf) — so the IAM/OIDC items in the standard checklist are N/A until those files are added; don't report them as findings against nonexistent resources, just note as a gap.

**Why:** These have shown up as findings across repeated audits without being fixed yet — worth flagging prominently rather than rediscovering each time, and worth checking first for whether they've since been addressed.

**How to apply:** Re-verify each of these still has zero matches (grep for the resource type) before reporting as a finding — don't assume the memory is still accurate. See [[portfolio-terraform-baseline]] for what's already solid.
