#!/bin/bash

# NOTE - This script is for use to build a basic Ubuntu cloud host.

# ideally there is a single command here that will add the machine to config management.
# thats a future state problem.

# Update the package indexes
echo "Updating apt repo package indexes"
sudo apt-get update

# Install all the packages
echo "installing our standard packages"
sudo apt-get -y -o DPkg::Options::="--force-confnew" install htop sysstat dstat iotop vim molly-guard unattended-upgrades git

# update all the things
echo "Applying all system updates"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

# now we clean up left over packages
echo "cleaning out old packages that are no longer required"
sudo apt-get -y auto-remove

# and then restart
echo "restarting"
sudo init 6
