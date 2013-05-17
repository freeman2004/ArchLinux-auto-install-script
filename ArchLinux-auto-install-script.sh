#!/bin/bash
#-------------------------------------------------------------------------------
#Created by Freeman 
#Contribution: Freeman
#-------------------------------------------------------------------------------
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)

set -x # Show the message of each command
#MODULE FUNCTIONS{{{ 

arch_chroot () { #{{{
arch-chroot $ARCH_ROOT /bin/bash -c "${1}"
}
#}}}

#}}}
# ARCH Root
ARCH_ROOT=/mnt

# file system
mkfs -t ext4  /dev/sda1 

# mount file system
mount /dev/sda1 $ARCH_ROOT

# pacman base
pacstrap -i $ARCH_ROOT base grub-bios
sleep 2

# fstab
genfstab -U -p $ARCH_ROOT >> $ARCH_ROOT/etc/fstab
sleep 2

# Set timezone and hwclock
arch_chroot 'hwclock --systohc --utc'
sleep 2

# Set hostname
arch_chroot 'echo "freeman-arch" > /etc/hostname'
sleep 2

# DHCP start
arch_chroot 'systemctl enable dhcpcd.service'
sleep 2

# locale
echo "LANG=zh_TW.UTF-8" > /etc/locale.conf
sleep 2

# locale-gen
arch_chroot 'sed -i \
-e "/^#en_US ISO-8859-1/s/#//" \
-e "/^#en_US.UTF-8 UTF-8/s/#//" \
-e "/^#zh_TW.UTF-8 UTF-8/s/#//" \
-e "/^#zh_TW BIG5/s/#//" \
/etc/locale.gen'
arch_chroot 'locale-gen'
sleep 2

# users and passwd
arch_chroot 'useradd -m -G users,wheel -s /bin/bash freeman'
arch_chroot 'echo "freeman:freeman" > passwd.txt'
arch_chroot 'echo "root:root" >> passwd.txt'
arch_chroot 'chpasswd < passwd.txt'
arch_chroot 'rm passwd.txt'
sleep 2

# mkinitcpio
arch_chroot 'mkinitcpio -p linux'
sleep 2

# grub
arch_chroot 'grub-mkconfig -o /boot/grub/grub.cfg'
arch_chroot 'grub-install /dev/sda'
sleep 2

#rm $ARCH_ROOT/vbox_arch_chroot.sh
umount $ARCH_ROOT/
shutdown -r now

# Reference:
# https://gist.github.com/kemadz/2517579
# https://github.com/helmuthdu/aui

[Arch Linux][USB][Update 2013-05-06] Install arch linux 2013 on the USB stick
