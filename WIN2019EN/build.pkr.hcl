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
  notes                = "Automate Template Builds by HashiCorp Packer on ${formatdate("YYYY-MM-DD-hh:mm", timestamp())}Z"
  iso_paths            = var.artifact.iso_paths
  cd_files = [
    "${path.cwd}/scripts/"
  ]
  boot_order       = var.artifact.vm_boot_order
  boot_wait        = var.artifact.vm_boot_wait
  boot_command     = var.artifact.vm_boot_command
  shutdown_command = var.artifact.vm_shutdown_command
  shutdown_timeout = var.artifact.common_shutdown_timeout
  cd_content = {
    "autounattend.xml" = templatefile("${abspath(path.root)}/autounattend.pkrtpl.hcl", {
      build_username       = var.artifact.build_username
      build_password       = var.build_password
      vm_inst_os_eval      = var.artifact.vm_inst_os_eval
      vm_inst_os_language  = var.artifact.vm_inst_os_language
      vm_inst_os_keyboard  = var.artifact.vm_inst_os_keyboard
      vm_inst_os_image     = var.artifact.vm_inst_os_image_standard_desktop
      vm_inst_os_key       = var.artifact.vm_inst_os_key
      vm_guest_os_language = var.artifact.vm_guest_os_language
      vm_guest_os_keyboard = var.artifact.vm_guest_os_keyboard
      vm_guest_os_timezone = var.artifact.vm_guest_os_timezone
    })
  }
  communicator        = var.artifact.communicator
  winrm_username      = var.artifact.build_username
  winrm_password      = var.build_password
  winrm_port          = var.artifact.communicator_port
  winrm_timeout       = var.artifact.communicator_timeout
  convert_to_template = var.artifact.common_template_conversion
}

build {
  sources = [
    "source.vsphere-iso.images"
  ]
  provisioner "windows-update" {
    search_criteria = "BrowseOnly=0 and IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 25
  }
  provisioner "windows-restart" {
    restart_timeout = "20m"
  }
  provisioner "windows-shell" {
    inline = ["%WINDIR%\\system32\\sysprep\\sysprep.exe /unattend:F:\\Autounattend.xml /generalize /quiet /quit"]
  }
}