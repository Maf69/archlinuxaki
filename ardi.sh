#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

pacman -Syy


pacman -S grub grub-btrfs btrfs-progs efibootmgr os-prober networkmanager network-manager-applet dialog base-devel wpa_supplicant mtools dosfstools reflector linux-headers avahi xdg-user-dirs pulseaudio xdg-utils gvfs gvfs-smb bluez bluez-utils cups alsa-utils pipewire pipewire-alsa pipewire-pulse bash-completion openssh rsync ipset samba flatpak ntfs-3g xorg sddm plasma kde-applications kdenetwork-filesharing cifs-utils powerdevil kde-gtk-config breeze-gtk packagekit-qt5 wireless_tools nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable acpid
systemctl enable sddm
systemctl enable cronie.service

useradd -mG wheel ardi
echo ardi:password | chpasswd


echo "ardi ALL=(ALL) ALL" >> /etc/sudoers.d/ardi

nano /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

nano /etc/mkinitcpio.conf

mkinitcpio -p linux

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
