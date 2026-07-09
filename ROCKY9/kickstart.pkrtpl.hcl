### Installs from the first attached CD-ROM/DVD on the system.
cdrom

### Performs the kickstart installation in text mode.
### By default, kickstart installations are performed in graphical mode.
text

### Accepts the End User License Agreement.
eula --agreed

### Sets the language to use during installation and the default language to use on the installed system.
lang ${vm_guest_os_language}

### Sets the default keyboard type for the system.
keyboard ${vm_guest_os_keyboard}

### Configure network information for target system and activate network devices in the installer environment (optional)
### --onboot	  enable device at a boot time
### --device	  device to be activated and / or configured with the network command
### --bootproto	  method to obtain networking configuration for device (default dhcp)
### --noipv6	  disable IPv6 on this device
network --device=${vm_network_device} --bootproto=dhcp --onboot=yes

### Lock the root account.
rootpw --lock

### The selected profile will restrict root login.
### Add a user that can login and escalate privileges.
user --name=${build_username} --iscrypted --password=${bcrypt(build_password,6)} --groups=wheel

### Configure firewall settings for the system.
### --enabled	reject incoming connections that are not in response to outbound requests
### --ssh		allow sshd service through the firewall
firewall --enabled --ssh

### Sets up the authentication options for the system.
### The SSDD profile sets sha512 to hash passwords. Passwords are shadowed by default
### See the manual page for authselect-profile for a complete list of possible options.
authselect select sssd

### Sets the state of SELinux on the installed system.
### Defaults to enforcing.
selinux --disabled

### Sets the system time zone.
timezone ${vm_guest_os_timezone}

### Partitioning
zerombr
clearpart --all --initlabel
autopart --type=plain
ignoredisk --only-use=${vm_disk_device}
autopart --type=plain --nohome 

### Modifies the default set of services that will run under the default runlevel.
services --enabled=NetworkManager,sshd

### Do not configure X on the installed system.
skipx

### Packages selection.
%packages --ignoremissing --excludedocs
@core
-iwl*firmware
%end

### Post-installation commands.
%post
dnf update -y
dnf install -y https://mirrors.aliyun.com/epel/epel-release-latest-9.noarch.rpm
sed -i 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
dnf install -y sudo cloud-init open-vm-tools perl net-tools vim lvm2
echo "${build_username} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${build_username}
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/ssh_pwauth: false/ssh_pwauth: true/" /etc/cloud/cloud.cfg
mkdir /home/${build_username}/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGu7vHIsAdqA2vMnENL/Ma97OgRp8tIKf+7yVxr6iGgVzUaR+Izp2OaDUe8NFvyWhU3GvpHwpkL5cEoKM+lnranJuBVIFU9Ggdpe18Hek/ZwERM8+v0oY1TJp9xDt1vVnNAq4YxdLMmYVQ8DWNB18Lz1NNDiDQMipIvs2DF631CHKH1dVKtwcU2aLAsnzhMp+PkW21yFkLEkXc2UfndEwC0X7+GRwp4hzlhDMC9F6wAZBeyq1/Ph71kjHBW39dRuh9YXrGH6j+Sf9z94q1RjLFiSgZ8AVkS0CCMhbsVZ5sbMpY9vMmHvxxGizGAzvFxnc8KQ+66yLpaNNTS1QJj4k6vBeHfW3Pezi7WgEFqJD4nBBej2woqRoT4pxnH/1FXAwGCPih62OsPmfgqFInhFOjJhZCAjsDtBT4iBATpEnicQjiyIau+sRIzSjQ1FMyWVsfp3NsHYWlk8XP0Wp6H3nzVkZEq8MTlhxQxEzu7LlgdgtFVE+P5ChhTHvxP3Cly/RepwVdKUPiNN9QnZdpD8KZnUHdtZKfgsCP1NvLUE3hUEhaSvL5fwL0pK06g8tYF8jSFmw81psemOtZAQ0iHYnZWPbgnR122fbo4PYEKgG12i6WSJ52MrD5cG8CAy5U5AuEV5vHEagG0qksIEl8hioRBrI0jYQ6SeeQmPOjaXyL9Q==" >> /home/${build_username}/.ssh/authorized_keys
chown -R ${build_username}:${build_username} /home/${build_username}/.ssh
chmod 700 /home/${build_username}/.ssh
chmod 600 /home/${build_username}/.ssh/authorized_keys
%end

### Reboot after the installation is complete.
### --eject attempt to eject the media before rebooting.
reboot --eject