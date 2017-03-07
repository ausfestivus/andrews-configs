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
#sudo apt-get update
sudo apt-get update

# Install all the packages
echo "installing our standard packages"
sudo apt-get -y -o DPkg::Options::="--force-confnew" install open-vm-tools-desktop htop sysstat dstat iotop python python-pip google-chrome-stable atom vim

# update all the things
echo "Applying all system updates"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

# Upgrade python-pip
echo "upgrading pip"
sudo -H pip install --upgrade pip

# install AWS cli and aws-shell
echo "installing awscli and aws-shell"
sudo -H pip install awscli aws-shell

# Disable guest access
echo "disabling guest access"
sudo sh -c 'printf "[Seat:*]\nallow-guest=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf'

# now we clean up left over packages
echo "cleaning out old packages that are no longer required"
sudo apt-get -y auto-remove

# and then restart
echo "restarting"
sudo init 6
