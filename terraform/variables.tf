variable "gcp_region" {
  default = "us-west1"
}

variable "gcp_zone" {
  default = "us-west1-a"
}

variable "gcp_credentials_file" {
  default = "/Users/echohack/.gcp/habitat-kubernetes-playland-6970193c95fc.json"
}

variable "gcp_project" {
  default = "habitat-kubernetes-playland"
}

variable "gcp_image_user" {
  default = "echohack"
}

variable "gcp_private_key" {
  default = "/Users/echohack/.ssh/google_compute_engine_decrypt"
}
