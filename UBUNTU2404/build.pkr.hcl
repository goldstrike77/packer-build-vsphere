variable "artifact" {}

variable "vcenter_password" {
  type      = string
  sensitive = true
}

variable "build_password" {
  type      = string
  sensitive = true
}

variable "build_password_encrypted" {
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
  notes                = "Automate Template Builds by HashiCorp Packer on ${formatdate("YYYY-MM-DD-hh:mm", timestamp())}Z"
  cd_content = {
    "/user-data" = templatefile("${abspath(path.root)}/user-data.pkrtpl.hcl", {
      build_username           = var.artifact.build_username
      build_password_encrypted = var.build_password_encrypted
      vm_guest_os_language     = var.artifact.vm_guest_os_language
      vm_guest_os_keyboard     = var.artifact.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.artifact.vm_guest_os_timezone
    })
  }
  cd_label   = var.artifact.cd_label
  iso_paths  = var.artifact.iso_paths
  boot_order = var.artifact.vm_boot_order
  boot_wait  = var.artifact.vm_boot_wait
  boot_command = [
    // This waits for 3 seconds, sends the "c" key, and then waits for another 3 seconds. In the GRUB boot loader, this is used to enter command line mode.
    "<wait3s>c<wait3s>",
    // This types a command to load the Linux kernel from the specified path with the 'autoinstall' option and the value of the 'data_source_command' local variable.
    // The 'autoinstall' option is used to automate the installation process.
    // The 'data_source_command' local variable is used to specify the kickstart data source configured in the common variables.
    "linux /casper/vmlinuz --- autoinstall ds='nocloud'",
    // This sends the "enter" key and then waits. This is typically used to execute the command and give the system time to process it.
    "<enter><wait>",
    // This types a command to load the initial RAM disk from the specified path.
    "initrd /casper/initrd",
    // This sends the "enter" key and then waits. This is typically used to execute the command and give the system time to process it.
    "<enter><wait>",
    // This types the "boot" command. This starts the boot process using the loaded kernel and initial RAM disk.
    "boot",
    // This sends the "enter" key. This is typically used to execute the command.
    "<enter>"
  ]
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
}