provider "google" {
    credentials =      file(var.secret)
    project     =      var.project
    region      =      var.region
    zone        =      "${var.region}-a"
}

resource "google_compute_address" "static" {
    name    = "vm-public-address"
    project = var.project
    region  = var.region
}

resource "google_compute_instance" "vm_instance" {
    name            = "instance-2"
    machine_type    = "e2-micro"
    zone            = "${var.region}-a"

    boot_disk {
        initialize_params {
            image = "rocky-linux-9-v20230203"
        }
    }

    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.static.address
        }
    }

    metadata = {
        "ssh-keys" = <<EOT
            ${var.user}:${file(var.publickeypath)}
            ${var.user-2}:${file(var.publickeypath-2)}
            EOT          
    }

    provisioner "remote-exec" {

        connection {    
            host        = "${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}"
            type        = "ssh"   
            user        = var.user
            private_key = file(var.privatekeypath)
        }

        inline = [
            "mkdir ~/test_file",
        ]
    }

    provisioner "file" {

        connection {    
            host        = "${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}"
            type        = "ssh"
            user        = var.user
            private_key = file(var.privatekeypath)
        }

        source        = "bash_script.sh"
        destination   = "${var.user-2_path-to-dir}bash_s.sh"
    }

    service_account {
        email   = var.email
        scopes  = ["compute-ro"]
    }

}
