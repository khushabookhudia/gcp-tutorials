# TERRFORM SCRIPT TO AUTOMATICALLY ADD SAME TAGS TO ALL THE INSTANCE DURING CREATION


provider "google" {
  version = "3.5.0"


  project = "terraform-ma-2020"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance_template" "default" {
  name        = "demo-ma-template"
  description = "This template is used to create app server instances."

  tags = ["app"]

  labels = {
    name = "app"
  }

  instance_description = "instance by terraform"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    boot         = true
  }
 network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

# -----------------------------------------------------------------------------------
# instance group manager

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

resource "google_compute_target_pool" "default" {

  name = "my-target-pool"
}
resource "google_compute_instance_group_manager" "terraform-ma-demo" {
  name = "terraform-ma-demo-igm"

  base_instance_name = "app"
  zone               = "us-central1-c"

  version {
    instance_template  = google_compute_instance_template.default.self_link
  }

  target_pools       = [google_compute_target_pool.default.self_link]
  target_size  = 2

  named_port {
    name = "customhttp"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.self_link
    initial_delay_sec = 300
  }
}


resource "google_compute_autoscaler" "default" {

  name   = "terraform-ma-demo-autoscaler"
  zone   = "us-central1-c"
  target = google_compute_instance_group_manager.terraform-ma-demo.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60
  }
}






resource "google_compute_instance" "default" {
  project           = "${data.google_project.google_compute_instance}"
  machine_type = "f1-micro"

  tags =["app"]
}





debian-9-stretch-v20200210

018045610744

025357083015






resource "google_compute_project_metadata_item" "default" {
  key   = "name"
  value = "app"
  project = "terraform-ma-2020"
}



resource "google_compute_project_metadata_item" "default" {
  key   = "my_metadata"
  value = "my_value"
}

resource "google_compute_project_metadata" "vm_instance" {
  metadata = {
    foo  = "bar"
    fizz = "buzz"
    "13" = "42"
  }
}


resource "google_compute_project_metadata" "terraform-instance-2" {
  metadata = {
    foo  = "bar"
    fizz = "buzz"
    "13" = "42"
  }
}
