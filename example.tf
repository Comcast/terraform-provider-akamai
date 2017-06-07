resource "akamai_gtm_domain" "property_test_domain" {
  name = "test.akadns.net"
  type = "basic"
}

resource "akamai_gtm_data_center" "property_test_dc1" {
  name = "property_test_dc1"
  domain = "${akamai_gtm_domain.property_test_domain.name}"
  country = "GB"
  continent = "EU"
  city = "Downpatrick"
  longitude = -5.582
  latitude = 54.367
  depends_on = [
    "akamai_gtm_domain.property_test_domain"
  ]
}

resource "akamai_gtm_data_center" "property_test_dc2" {
  name = "property_test_dc2"
  domain = "${akamai_gtm_domain.property_test_domain.name}"
  country = "IS"
  continent = "EU"
  city = "Snæfellsjökull"
  longitude = -23.776
  latitude = 64.808
  depends_on = [
    "akamai_gtm_data_center.property_test_dc1"
  ]
}

resource "akamai_gtm_property" "test_property" {
  domain = "${akamai_gtm_domain.property_test_domain.name}"
  type = "weighted-round-robin"
  name = "test_property"
  balance_by_download_score = false
  dynamic_ttl = 300
  failover_delay = 0
  failback_delay = 0
  handout_mode = "normal"
  health_threshold = 0
  health_max = 0
  health_multiplier = 0
  load_imbalance_percentage = 10
  ipv6 = false
  score_aggregation_type = "mean"
  static_ttl = 600
  stickiness_bonus_percentage = 50
  stickiness_bonus_constant = 0
  use_computed_targets = false
  liveness_test {
    name = "health check"
    test_object = "/status"
    test_object_protocol = "HTTP"
    test_interval = 60
    disable_nonstandard_port_warning = false
    http_error_4xx = true
    http_error_3xx = true
    http_error_5xx = true
    test_object_port = 80
    test_timeout = 25
  }
  traffic_target {
    enabled = true
    data_center_id = "${akamai_gtm_data_center.property_test_dc1.id}"
    weight = 50.0
    name = "${akamai_gtm_data_center.property_test_dc1.name}"
    servers = [
      "1.2.3.4",
      "1.2.3.5"
    ]
  }
  traffic_target {
    enabled = true
    data_center_id = "${akamai_gtm_data_center.property_test_dc2.id}"
    weight = 50.0
    name = "${akamai_gtm_data_center.property_test_dc2.name}"
    servers = [
      "1.2.3.6",
      "1.2.3.7"
    ]
  }
}
