resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  project            = var.project_id
  disable_on_destroy = false
}

resource "google_project_service" "dns" {
  service            = "dns.googleapis.com"
  project            = var.project_id
  disable_on_destroy = false
}

resource "google_compute_global_address" "customer_traffic" {
  name    = "customer-traffic-ip"
  project = var.project_id

  depends_on = [google_project_service.compute]
}

resource "google_compute_security_policy" "customer_traffic_waf" {
  name    = "customer-traffic-waf"
  project = var.project_id

  rule {
    action   = "deny(403)"
    priority = 1000

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-v33-stable')"
      }
    }
    description = "Block common SQL injection attacks at the global edge."
  }

  rule {
    action   = "deny(403)"
    priority = 1100

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('xss-v33-stable')"
      }
    }
    description = "Block common cross-site scripting attacks at the global edge."
  }

  rule {
    action   = "allow"
    priority = 2147483647

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule."
  }

  depends_on = [google_project_service.compute]
}

resource "google_dns_managed_zone" "customer_traffic" {
  name        = replace(var.dns_zone_name, ".", "-")
  project     = var.project_id
  dns_name    = "${trimsuffix(var.dns_zone_name, ".")}."
  description = "Public DNS zone for customer traffic."

  depends_on = [google_project_service.dns]
}

resource "google_dns_record_set" "customer_traffic" {
  name         = "${trimsuffix(var.customer_domain, ".")}."
  managed_zone = google_dns_managed_zone.customer_traffic.name
  project      = var.project_id
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.customer_traffic.address]
}