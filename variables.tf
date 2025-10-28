# From OCI account.
variable "tenancy_id" {
  type = string
}
variable "availability_domain" {
  type    = string
  default = "MEmO:UK-LONDON-1-AD-2"
}

variable "vm_image" {
  type = string
  default = "ocid1.image.oc1.uk-london-1.aaaaaaaaiqj4r4akxsvm25b5ky2fw6jd2bytcktj7ub3ar7muxrbgdbyo2wa"
}
variable "ssh_public_key_path" {
  type = string
  default = "~/.ssh/id_ed25519.pub"
}
variable "data_volume_size_gb" {
  type    = number
  default = 150
}
