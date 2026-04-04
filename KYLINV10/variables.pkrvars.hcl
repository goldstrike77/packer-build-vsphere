artifact = {
  vsphere_endpoint            = "vcenter.esxi.lab"
  vsphere_username            = "administrator@vsphere.local"
  vsphere_insecure_connection = true
  vsphere_datacenter          = "cn-north"
  vsphere_cluster             = "cn-north-1"
  vsphere_datastore           = "ds-san-lun1"
  vsphere_network             = "vlan-trunk-portrgoup"
  vm_name                     = "template-KYLINV10"
  vm_guest_os_type            = "other4xLinux64Guest"
  vm_firmware                 = "efi"
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
    "[ds-san-lun1] ISOs/Kylin-Server-V10-SP3-2403-Release-20240426-X86_64.iso"
  ]
  vm_boot_order = "disk,cdrom"
  boot_command = [
    // This sends the "up arrow" key, typically used to navigate through boot menu options.
    "<up>",
    // This sends the "e" key. In the GRUB boot loader, this is used to edit the selected boot menu option.
    "e",
    // This sends two "down arrow" keys, followed by the "end" key, and then waits. This is used to navigate to a specific line in the boot menu option's configuration.
    "<down><down><end><wait>",
    // This types the string "text" followed by the value of the 'data_source_command' local variable.
    // This is used to modify the boot menu option's configuration to boot in text mode and specify the kickstart data source configured in the common variables.
    "text ksdevice=bootif inst.ks=cdrom:/kickstart.cfg",
    // This sends the "enter" key, waits, turns on the left control key, sends the "x" key, and then turns off the left control key. This is used to save the changes and exit the boot menu option's configuration, and then continue the boot process.
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  vm_boot_wait               = "5s"
  common_shutdown_timeout    = "1h"
  build_username             = "ecsadmin"
  vm_guest_os_language       = "en_US"
  vm_guest_os_keyboard       = "us"
  vm_guest_os_timezone       = "Asia/Shanghai"
  vm_guest_os_family         = "linux"
  vm_guest_os_name           = "kylin"
  vm_guest_os_version        = "v10sp3"
  communicator_port          = 22
  communicator_timeout       = "1h"
  common_ip_wait_timeout     = "1h"
  communicator               = "ssh"
  vm_network_device          = "ens192"
  common_template_conversion = true
  vm_disk_device             = "sda"
}