#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service
systemctl set-default multi-user.target
systemctl enable NetworkManager

# Clone dotfiles
mkdir -p /etc/skel/github
git -C /etc/skel/github clone https://github.com/egeldenhuys/dotfiles --depth=1

# Install atom packages
echo "Installing atom packages..."
bash /etc/skel/github/dotfiles/install-atom-packages.sh
mv /root/.atom /etc/skel/

# Set mirrors
cp -f /etc/custom/mirrorlist /etc/pacman.d/mirrorlist

# Add default user account and set passwords
useradd -s /usr/bin/zsh -m evert
echo -en "password\npassword" | passwd evert
echo -en "password\npassword" | passwd root



