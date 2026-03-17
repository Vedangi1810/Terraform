resource "google_service_account" "default" {
    account_id = "my-custom-sa"
    display_name = "Custom SA for VM instance"
}

resource "google_compute_instance" "default" {
    name = "my-instance"
    machine_type = "n2-standard-2"
    zone = "us-west1-c" #optional

    # optional
    tags = ["test","try"]

    # req
    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
            labels = {
                my_label = "value"
            }
        }
    }

    # Locsl SSD disk
    scratch_disk {
        interface = "NVME"
    }

    # req
    network_interface {
        network = "default"
    }

    metadata = {
        test = "try"
    }

    metadata_startup_script = "echo hi > /test.txt"

    # optional
    service_account {
        email = google_service_account.default.email
        scopes = ["cloud-platform"] #req
    }
}
