resource "oci_identity_compartment" "backup_server" {
  compartment_id = var.tenancy_id
  name           = "backup_server_compartment"
  description    = "backup_server_compartment"
  enable_delete  = true
}

resource "oci_core_vcn" "backup_server" {
  compartment_id = oci_identity_compartment.backup_server.id
  cidr_block     = "10.1.0.0/16"
  display_name   = "backup_server net"
  dns_label      = "backupserver"
}

resource "oci_core_subnet" "backup_server" {
  compartment_id    = oci_identity_compartment.backup_server.id
  vcn_id            = oci_core_vcn.backup_server.id
  cidr_block        = "10.1.2.0/24"
  display_name      = "backup_server subnet"
  dns_label         = "subnet1"
  security_list_ids = [oci_core_vcn.backup_server.default_security_list_id]
  route_table_id    = oci_core_vcn.backup_server.default_route_table_id
  dhcp_options_id   = oci_core_vcn.backup_server.default_dhcp_options_id
}

resource "oci_core_default_route_table" "backup_server" {
  manage_default_resource_id = oci_core_vcn.backup_server.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.backup_server.id
  }
}

resource "oci_core_default_security_list" "backup_server" {
  manage_default_resource_id = oci_core_vcn.backup_server.default_security_list_id
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6" # TCP
  }
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}

resource "oci_core_internet_gateway" "backup_server" {
  compartment_id = oci_identity_compartment.backup_server.id
  vcn_id         = oci_core_vcn.backup_server.id
  display_name   = "backup_server"
}

resource "oci_core_volume" "backup_server_data" {
  compartment_id      = oci_core_instance.backup_server.compartment_id
  availability_domain = oci_core_instance.backup_server.availability_domain
  size_in_gbs         = var.data_volume_size_gb
  display_name        = "data"
}
resource "oci_core_volume_attachment" "backup_server" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.backup_server.id
  volume_id       = oci_core_volume.backup_server_data.id
  device          = "/dev/oracleoci/oraclevdb"
}

resource "oci_core_instance" "backup_server" {
  compartment_id      = oci_identity_compartment.backup_server.id
  availability_domain = var.availability_domain
  display_name        = "backup_server"

  shape = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.backup_server.id
    display_name     = "primary"
    hostname_label   = "backupserver"
    assign_public_ip = true
  }

  is_pv_encryption_in_transit_enabled = "true"
  source_details {
    source_type             = "image"
    source_id               = var.vm_image
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
}

output "vm_ip_address" {
  value = oci_core_instance.backup_server.public_ip
}
