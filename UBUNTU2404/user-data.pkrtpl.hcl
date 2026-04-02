#cloud-config
autoinstall:
  version: 1
  apt:
    geoip: false
    preserve_sources_list: false
    primary:
      - arches: [amd64, i386]
        uri: http://mirrors.aliyun.com/ubuntu
      - arches: [default]
        uri: http://mirrors.aliyun.com/ubuntu-ports
    security:
      - arches: [amd64, i386]
        uri: http://mirrors.aliyun.com/ubuntu
      - arches: [default]
        uri: http://mirrors.aliyun.com/ubuntu-ports
  early-commands:
    - sudo systemctl stop ssh
  locale: ${vm_guest_os_language}
  keyboard:
    layout: ${vm_guest_os_keyboard}
  identity:
    hostname: ubuntu-server
    username: ${build_username}
    password: "${bcrypt(build_password,6)}"
  storage:
    layout:
      name: lvm
      sizing-policy: all
  ssh:
    install-server: true
    allow-pw: true
  packages:
    - openssh-server
    - open-vm-tools
    - cloud-init
    - net-tools
  user-data:
    disable_root: false
    timezone: ${vm_guest_os_timezone}
  late-commands:
    - echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
    - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}
    - curtin in-target --target=/target -- sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
    - curtin in-target --target=/target -- update-grub