#cloud-config
autoinstall:
  version: 1
  apt:
    geoip: false
    preserve_sources_list: false
    primary:
      - arches: [amd64, i386]
        uri: http://mirrors.163.com/ubuntu
      - arches: [default]
        uri: http://mirrors.163.com/ubuntu-ports
    security:
      - arches: [amd64, i386]
        uri: http://mirrors.163.com/ubuntu
      - arches: [default]
        uri: http://mirrors.163.com/ubuntu-ports
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
    users:
      - name: ${build_username}
        gecos: System Operator
        groups: sudo
        sudo: ['ALL=(ALL) NOPASSWD:ALL']        
        lock_passwd: false
        shell: /bin/bash
        ssh-authorized-keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGu7vHIsAdqA2vMnENL/Ma97OgRp8tIKf+7yVxr6iGgVzUaR+Izp2OaDUe8NFvyWhU3GvpHwpkL5cEoKM+lnranJuBVIFU9Ggdpe18Hek/ZwERM8+v0oY1TJp9xDt1vVnNAq4YxdLMmYVQ8DWNB18Lz1NNDiDQMipIvs2DF631CHKH1dVKtwcU2aLAsnzhMp+PkW21yFkLEkXc2UfndEwC0X7+GRwp4hzlhDMC9F6wAZBeyq1/Ph71kjHBW39dRuh9YXrGH6j+Sf9z94q1RjLFiSgZ8AVkS0CCMhbsVZ5sbMpY9vMmHvxxGizGAzvFxnc8KQ+66yLpaNNTS1QJj4k6vBeHfW3Pezi7WgEFqJD4nBBej2woqRoT4pxnH/1FXAwGCPih62OsPmfgqFInhFOjJhZCAjsDtBT4iBATpEnicQjiyIau+sRIzSjQ1FMyWVsfp3NsHYWlk8XP0Wp6H3nzVkZEq8MTlhxQxEzu7LlgdgtFVE+P5ChhTHvxP3Cly/RepwVdKUPiNN9QnZdpD8KZnUHdtZKfgsCP1NvLUE3hUEhaSvL5fwL0pK06g8tYF8jSFmw81psemOtZAQ0iHYnZWPbgnR122fbo4PYEKgG12i6WSJ52MrD5cG8CAy5U5AuEV5vHEagG0qksIEl8hioRBrI0jYQ6SeeQmPOjaXyL9Q==
  late-commands:
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - curtin in-target --target=/target -- sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
    - curtin in-target --target=/target -- update-grub