provider "google" {
  credentials = "${file("${var.gcp_credentials_file}")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "google_dns_record_set" "national-parks" {
  name = "national-parks.${google_dns_managed_zone.prod.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.prod.name}"

  rrdatas = ["${google_compute_instance.national-parks.network_interface.0.access_config.0.assigned_nat_ip}"]
}

resource "google_compute_target_pool" "national-parks" {
  name      = "national-parks"
  instances = ["${google_compute_instance.national-parks.self_link}"]
}

resource "google_compute_forwarding_rule" "tomcat" {
  name       = "tomcat"
  target     = "${google_compute_target_pool.national-parks.self_link}"
  port_range = "8080"
}

resource "google_compute_instance" "np-mongodb" {
  name         = "np-mongodb"
  machine_type = "n1-standard-1"
  zone         = "${var.gcp_zone}"

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20171011"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  count = 1

  lifecycle = {
    create_before_destroy = true
  }

  connection {
    user        = "${var.gcp_image_user}"
    private_key = "${file("${var.gcp_private_key}")}"
  }

  provisioner "file" {
    content     = "${data.template_file.install_hab.rendered}"
    destination = "/tmp/install_hab.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.sup_service.rendered}"
    destination = "/home/echohack/hab-sup.service"
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=no -i ${var.gcp_private_key} /Users/echohack/code/national-parks/hab-mongo/results/echohack-np-mongodb-3.2.9-20171026032947-x86_64-linux.hart ${var.gcp_image_user}@${self.network_interface.0.access_config.0.assigned_nat_ip}:/home/echohack"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --group hab",
      "sudo useradd -g hab hab",
      "chmod +x /tmp/install_hab.sh",
      "sudo /tmp/install_hab.sh",
      "sudo mv /home/echohack/hab-sup.service /etc/systemd/system/hab-sup.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl start hab-sup",
      "sudo systemctl enable hab-sup",
      "sudo hab pkg install /home/echohack/echohack-np-mongodb-3.2.9-20171026032947-x86_64-linux.hart",
      "sudo hab start echohack/np-mongodb --strategy at-once",
    ]
  }
}

resource "google_compute_instance" "national-parks" {
  name         = "national-parks"
  machine_type = "n1-standard-1"
  zone         = "${var.gcp_zone}"

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20171011"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  count = 1

  lifecycle = {
    create_before_destroy = true
  }

  connection {
    user        = "${var.gcp_image_user}"
    private_key = "${file("${var.gcp_private_key}")}"
  }

  provisioner "file" {
    content     = "${data.template_file.install_hab.rendered}"
    destination = "/tmp/install_hab.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.sup_service.rendered}"
    destination = "/home/echohack/hab-sup.service"
  }

  provisioner "local-exec" {
    command = "scp -oStrictHostKeyChecking=no -i ${var.gcp_private_key} /Users/echohack/code/national-parks/results/echohack-national-parks-5.7.0-20171026050054-x86_64-linux.hart ${var.gcp_image_user}@${self.network_interface.0.access_config.0.assigned_nat_ip}:/home/echohack"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --group hab",
      "sudo useradd -g hab hab",
      "chmod +x /tmp/install_hab.sh",
      "sudo /tmp/install_hab.sh",
      "sudo mv /home/echohack/hab-sup.service /etc/systemd/system/hab-sup.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl start hab-sup",
      "sudo systemctl enable hab-sup",
      "sudo hab pkg install /home/echohack/echohack-national-parks-5.7.0-20171026050054-x86_64-linux.hart",
      "sudo hab start echohack/national-parks --peer ${google_compute_instance.np-mongodb.network_interface.0.address} --bind database:np-mongodb.default --strategy at-once",
    ]
  }
  depends_on = ["google_compute_instance.np-mongodb"]
}

resource "google_dns_managed_zone" "prod" {
  name     = "prod-zone"
  dns_name = "habitat-kubernetes-playland.com."
}

// Templates
data "template_file" "sup_service" {
  template = "${file("${path.module}/templates/hab-sup.service")}"

  vars {
    flags = "--auto-update"
  }
}

data "template_file" "install_hab" {
  template = "${file("${path.module}/templates/install-hab.sh")}"
}
