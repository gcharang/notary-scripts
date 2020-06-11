
https://docs.ovh.com/ie/en/vps/network-ipaliasing-vps/ --> wrong?

cat /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
network: {config: disabled}

```bash
cat /etc/network/interfaces.d/50-cloud-init.cfg

# This file is generated from information provided by
# the datasource.  Changes to it will not persist across an instance.
# To disable cloud-init's network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
auto lo
iface lo inet loopback

auto enp1s0f0
iface enp1s0f0 inet static
address 139.99.244.88
netmask 255.255.255.255
```

https://docs.ovh.com/ca/en/dedicated/network-ipaliasing/
^^^ --> to add additional ips not a single static ip

https://docs.ovh.com/gb/en/public-cloud/make-failover-ip-configuration-persistent/
https://linuxconfig.org/how-to-set-a-static-ip-address-on-debian-10-buster
https://askubuntu.com/questions/459140/why-dhclient-is-still-running-when-i-choose-static-ip
https://wiki.debian.org/NetworkConfiguration


proxmox-ve-6 -- deb10 vm https://serverok.in/debian-9-ovh-bridge-network-configuration --> works 

```bash
# Instructions in the form of a script to set ip of a debian 10 VM in proxmox ve 6

# use as root
# usage: ./ovh-proxmox-deb-10-vm-net-init.sh MAIN_SERVER_IP FAILOVER_IP
MAIN_SERVER_IP=$1
FAILOVER_IP=$2
GATEWAY_IP=$(awk -F"." '{print $1"."$2"."$3".254"}' <<<$MAIN_SERVER_IP)
if [ $# -eq 3 ]; then
    INTERFACE_LABEL=$3
else
    INTERFACE_LABEL="ens18"
fi

cat <<-EOL >/etc/network/interfaces
auto lo 
iface lo inet loopback

auto $INTERFACE_LABEL
iface $INTERFACE_LABEL inet static
    address $FAILOVER_IP
    netmask 255.255.255.255
    broadcast $FAILOVER_IP
    post-up ip route add $GATEWAY_IP dev $INTERFACE_LABEL
    post-up ip route add default via $GATEWAY_IP dev $INTERFACE_LABEL
    pre-down ip route del $GATEWAY_IP dev $INTERFACE_LABEL
    pre-down ip route del default via $GATEWAY_IP dev $INTERFACE_LABEL
EOL

/etc/init.d/networking restart
```

^ after doing that, write `nameserver 8.8.8.8` to /etc/resolv.conf and reboot. now network works and domains names are resolved

add sources to `/etc/apt/sources/list`
use nano. mark text : `ctrl+^` , copy text `alt+^`, paste text `ctrl+u`, cut `ctrl+k`
```
deb http://deb.debian.org/debian buster main contrib non-free
deb-src http://deb.debian.org/debian buster main contrib non-free

deb http://deb.debian.org/debian-security/ buster/updates main contrib non-free
deb-src http://deb.debian.org/debian-security/ buster/updates main contrib non-free

deb http://deb.debian.org/debian buster-updates main contrib non-free
deb-src http://deb.debian.org/debian buster-updates main contrib non-free
```

install openssh-server
edit /etc/ssh/sshd_config `PermitRootLogin yes`
set password `passwd`
connect from desktop using `ssh root@failoverIP`
add a ssh pubkey to ~/.ssh/authorized_keys
disconnect and connect through pubkey auth
install git, clone freshubuntu
run it