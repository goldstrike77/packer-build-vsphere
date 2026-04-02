artifact = {
  vsphere_endpoint            = "vcenter.esxi.lab"
  vsphere_username            = "administrator@vsphere.local"
  vsphere_insecure_connection = true
  vsphere_datacenter          = "cn-north"
  vsphere_cluster             = "cn-north-1"
  vsphere_datastore           = "ds-san-lun1"
  vsphere_network             = "vlan-trunk-portrgoup"
  vm_name                     = "template-UBUNTU2404"
  vm_guest_os_type            = "ubuntu64Guest"
  vm_firmware                 = "efi-secure"
  vm_cpu_count                = 2
  vm_cpu_cores                = 2
  vm_cpu_hot_add              = false
  vm_mem_size                 = 8192
  vm_mem_hot_add              = false
  vm_cdrom_type               = "sata"
  vm_disk_controller_type     = ["pvscsi"]
  vm_disk_size                = 40960
  vm_disk_thin_provisioned    = true
  vm_network_card             = "vmxnet3"
  common_remove_cdrom         = true
  vm_cdrom_count              = 1
  tools_upgrade_policy        = true
  iso_paths = [
    "[ds-san-lun1] ISOs/ubuntu-24.04.4-live-server-amd64.iso"
  ]
  vm_boot_order              = "disk,cdrom"
  boot_command               = ["<esc><esc><esc><esc>e<wait>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del>", "<del><del><del><del><del><del><del><del><del>", "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"<enter><wait>", "initrd /casper/initrd<enter><wait>", "boot<enter>", "<enter><f10><wait>"]
  vm_boot_wait               = "5s"
  common_shutdown_timeout    = "1h"
  build_username             = "ecsadmin"
  vm_guest_os_language       = "en_US"
  vm_guest_os_keyboard       = "us"
  vm_guest_os_timezone       = "Asia/Shanghai"
  vm_guest_os_family         = "linux"
  vm_guest_os_name           = "server"
  vm_guest_os_version        = "24.04-lts"
  communicator_port          = 22
  communicator_timeout       = "1h"
  common_ip_wait_timeout     = "1h"
  communicator               = "ssh"
  vm_network_device          = "ens192"
  common_template_conversion = true
  cd_label                   = "cidata"
}