artifact = {
  vsphere_endpoint            = "vcenter.esxi.lab"
  vsphere_username            = "administrator@vsphere.local"
  vsphere_insecure_connection = true
  vsphere_datacenter          = "cn-north"
  vsphere_cluster             = "cn-north-1"
  vsphere_datastore           = "ds-san-lun1"
  vsphere_network             = "vlan-trunk-portrgoup"
  vm_name                     = "template-WIN2019"
  vm_guest_os_type            = "windows2019srv_64Guest"
  vm_firmware                 = "efi-secure"
  vm_cpu_count                = 4
  vm_cpu_cores                = 2
  vm_cpu_hot_add              = false
  vm_mem_size                 = 8192
  vm_mem_hot_add              = false
  vm_cdrom_type               = "sata"
  vm_disk_controller_type     = ["pvscsi"]
  vm_disk_size                = 130048
  vm_disk_thin_provisioned    = true
  vm_network_card             = "vmxnet3"
  common_remove_cdrom         = true
  vm_cdrom_count              = 1
  tools_upgrade_policy        = true
  iso_paths_cn = [
    "[ds-san-lun1] ISOs/SW_DVD9_Win_Server_DE_2019_64Bit_ChnSimp_DC_STD.iso",
    "[ds-san-lun1] ISOs/VMware-tools-windows-13.1.0-25218885.iso"
  ]
  iso_paths_en = [
    "[ds-san-lun1] ISOs/SW_DVD9_Win_Server_DE_2019_64Bit_English_DC_STD.iso",
    "[ds-san-lun1] ISOs/VMware-tools-windows-13.1.0-25218885.iso"
  ]
  vm_boot_order                     = "disk,cdrom"
  vm_boot_wait                      = "2s"
  vm_boot_command                   = ["<spacebar>"]
  vm_shutdown_command               = "C:\\Windows\\System32\\Sysprep\\sysprep.exe /unattend:F:\\Autounattend.xml /generalize /oobe /shutdown /quiet"
  common_shutdown_timeout           = "1h"
  build_username                    = "administrator"
  vm_inst_os_eval                   = false
  vm_inst_os_language_en            = "en-US"
  vm_inst_os_language_cn            = "zh-CN"
  vm_inst_os_keyboard               = "en-US"
  vm_inst_os_image_standard_desktop = "Windows Server 2019 SERVERSTANDARD"
  vm_inst_os_key                    = "N69G4-B89J2-4G8F4-WWYCC-J464C"
  vm_guest_os_language_en           = "en-US"
  vm_guest_os_language_cn           = "zh-CN"
  vm_guest_os_keyboard              = "en-US"
  vm_guest_os_timezone              = "UTC"
  vm_guest_os_family                = "windows"
  vm_guest_os_name                  = "server"
  vm_guest_os_version               = "2019"
  vm_guest_os_edition_standard      = "standard"
  communicator                      = "winrm"
  communicator_port                 = 5985
  communicator_timeout              = "1h"
  common_template_conversion        = true
}