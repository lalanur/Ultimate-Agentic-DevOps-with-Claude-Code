---
name: portfolio-site-cost-review-20260709
description: AWS cost optimization review for portfolio site S3/CloudFront infrastructure
metadata:
  type: project
---

## Portfolio Site Infrastructure Cost Review (2026-07-09)

Static HTML/CSS portfolio site deployed to ap-south-1 via S3 + CloudFront + Terraform.

### Key Findings

1. **CloudFront PriceClass_200 in use (HIGH IMPACT)**
   - Currently paying for 100 edge locations globally (North America, Europe, Africa, parts of Middle East)
   - Portfolio site traffic unlikely to benefit from this scope
   - Recommended: PriceClass_100 (50 edge locations: North America, Europe, Middle East)
   - Estimated savings: 30-50% on CloudFront data transfer costs depending on traffic patterns

2. **S3 multipart upload cleanup missing (MEDIUM IMPACT)**
   - No lifecycle rule to clean up failed/incomplete multipart uploads
   - These orphaned parts incur S3 storage costs indefinitely
   - Portfolio site may accumulate these if deployments fail

3. **404 error caching TTL is very low (LOW IMPACT)**
   - Currently 10 seconds; increases origin requests for non-existent assets
   - Could increase to 300-3600 to reduce S3 GET requests for common 404s

### Already Optimized (No Action Needed)
- S3 versioning disabled (good for portfolio site)
- No CloudFront logging configured (avoids log storage costs)
- Using AWS-managed CachingOptimized policy (reasonable TTLs)
- Only one cache behavior (no redundancy)
- IPv6 enabled (no cost impact)
