variable "artifact" {}

variable "vcenter_password" {
  type      = string
  sensitive = true
}

variable "build_password" {
  type      = string
  sensitive = true
}

source "vsphere-iso" "images" {
  vcenter_server       = var.artifact.vsphere_endpoint
  username             = var.artifact.vsphere_username
  password             = var.vcenter_password
  insecure_connection  = var.artifact.vsphere_insecure_connection
  datacenter           = var.artifact.vsphere_datacenter
  cluster              = var.artifact.vsphere_cluster
  datastore            = var.artifact.vsphere_datastore
  vm_name              = var.artifact.vm_name
  guest_os_type        = var.artifact.vm_guest_os_type
  firmware             = var.artifact.vm_firmware
  CPUs                 = var.artifact.vm_cpu_count
  cpu_cores            = var.artifact.vm_cpu_cores
  CPU_hot_plug         = var.artifact.vm_cpu_hot_add
  RAM                  = var.artifact.vm_mem_size
  RAM_hot_plug         = var.artifact.vm_mem_hot_add
  cdrom_type           = var.artifact.vm_cdrom_type
  disk_controller_type = var.artifact.vm_disk_controller_type
  storage {
    disk_size             = var.artifact.vm_disk_size
    disk_controller_index = 0
    disk_thin_provisioned = var.artifact.vm_disk_thin_provisioned
  }
  network_adapters {
    network      = var.artifact.vsphere_network
    network_card = var.artifact.vm_network_card
  }
  remove_cdrom         = var.artifact.common_remove_cdrom
  reattach_cdroms      = var.artifact.vm_cdrom_count
  tools_upgrade_policy = var.artifact.tools_upgrade_policy
  notes                = "Automate Builds by HashiCorp Packer on ${formatdate("YYYY-MM-DD-hh:mm", timestamp())}Z"
  cd_content = {
    "/kickstart.cfg" = templatefile("${abspath(path.root)}/kickstart.pkrtpl.hcl", {
      build_username       = var.artifact.build_username
      build_password       = var.build_password
      vm_guest_os_language = var.artifact.vm_guest_os_language
      vm_guest_os_keyboard = var.artifact.vm_guest_os_keyboard
      vm_guest_os_timezone = var.artifact.vm_guest_os_timezone
      vm_network_device    = var.artifact.vm_network_device
      vm_disk_device       = var.artifact.vm_disk_device
    })
  }
  iso_paths           = var.artifact.iso_paths
  boot_order          = var.artifact.vm_boot_order
  boot_wait           = var.artifact.vm_boot_wait
  boot_command        = var.artifact.boot_command
  ip_wait_timeout     = var.artifact.common_ip_wait_timeout
  shutdown_command    = "echo '${var.build_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout    = var.artifact.common_shutdown_timeout
  communicator        = var.artifact.communicator
  ssh_timeout         = var.artifact.communicator_timeout
  ssh_username        = var.artifact.build_username
  ssh_password        = var.build_password
  convert_to_template = var.artifact.common_template_conversion
}

build {
  sources = [
    "source.vsphere-iso.images"
  ]
  provisioner "shell" {
    inline = [
      "sleep 5",
      "sudo dnf remove --oldinstallonly -y",
      "sudo cloud-init clean",
      "rm /etc/udev/rules.d/70-persistent-net.rules",
      "rm /etc/sysconfig/network-scripts/ifcfg-${var.artifact.vm_network_device}"
    ]
  }
}