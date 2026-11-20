package main

import rego.v1

# Policy 1: Enforce uniform_bucket_level_access = true on google_storage_bucket resources
deny contains msg if {
    some name
    bucket := input.resource.google_storage_bucket[name]
    bucket.uniform_bucket_level_access != true
    msg := sprintf("google_storage_bucket.%s must set uniform_bucket_level_access = true", [name])
}

# Policy 2: Block 0.0.0.0/0 ingress on SSH (22) or RDP (3389) in google_compute_firewall
deny contains msg if {
    some name
    fw := input.resource.google_compute_firewall[name]
    "0.0.0.0/0" in fw.source_ranges
    some allow_rule
    allow := fw.allow[allow_rule]
    some port
    p := allow.ports[port]
    p in {"22", "3389"}
    msg := sprintf("google_compute_firewall.%s cannot allow 0.0.0.0/0 on port %s", [name, p])
}
