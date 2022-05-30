

# Creates a GCP VM Instance.
resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["http-server","https-server"]
  labels       = var.labels

 boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  scheduling {
     preemptible = true
      automatic_restart = false
     provisioning_model = "SPOT"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }


  lifecycle {
    ignore_changes = [attached_disk]
  }
  
  #metadata_startup_script = data.template_file.nginx.rendered
  metadata_startup_script = <<-EOF
  sudo bash -c 'echo "*****    Installing Nginx    *****" > 1.txt'
  sudo bash -c 'wget https://raw.githubusercontent.com/eftech13/eftech13/main/script/installodoo.sh > 2.txt'
  sudo bash -c 'chmod 755 installodoo.sh > 3.txt'
  sudo bash -c './installodoo.sh > 4.txt' 
  sudo bash -c 'Done > 5.txt'
  EOF
  

}

resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = "my-firewall-rule"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
}
