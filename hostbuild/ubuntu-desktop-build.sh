#!/bin/bash

# configure our base Ubuntu image
# based on https://confluence.diaxion.com/display/~abest/Ubuntu+Dev+VM+Build


# NOTE - not required on a desktop machine.
#echo "recreating SSH server host keys"
## This regenerates our host keys
#sudo sh -c "dpkg-reconfigure openssh-server"

# add the Google Chrome repo so we can install Chrome a little later.
# https://www.ubuntuupdates.org/ppa/google_chrome?dist=stable
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

# add the Atom repo
# Atom unofficial PPA: http://tipsonubuntu.com/2016/08/05/install-atom-text-editor-ubuntu-16-04/
sudo add-apt-repository ppa:webupd8team/atom

# Update the package indexes
echo "Updating apt repo package indexes"
#sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade
sudo apt-get update && sudo apt-get dist-upgrade

# Install all the packages
echo "installing our standard packages"
sudo apt-get -y -o DPkg::Options::="--force-confnew" install open-vm-tools-desktop htop sysstat dstat iotop python python-pip google-chrome-stable atom

# Upgrade python-pip
echo "upgrading pip"
sudo pip install --upgrade pip

# install AWS cli and aws-shell
sudp pip install awscli aws-shell

# Disable guest access
echo "disabling guest access"
sudo bash -c "cat /etc/lightdm/lightdm.conf.d/50-no-guest.conf" << "EOF"
[SeatDefaults]
allow-guest=false
EOF

# now we clean up left over packages
sudo apt-get auto-remove

# Configure automatic security updates
echo "configuring auto install of security updates"
sudo bash -c "cat > /etc/apt/apt.conf.d/20auto-upgrades" << "EOF"
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
sudo /etc/init.d/unattended-upgrades restart

# and then restart
#sudo init 6
