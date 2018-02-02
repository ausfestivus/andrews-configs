#!/bin/bash

# NOTE - This script is for use to build a basic Ubuntu cloud host.

# ideally there is a single command here that will add the machine to config management.
# thats a future state problem.

# Update the package indexes
/bin/echo "Updating apt repo package indexes"
/usr/bin/sudo apt-get update

# Install all the packages
/bin/echo "installing our standard packages"
/usr/bin/sudo /usr/bin/apt-get -y -o DPkg::Options::="--force-confnew" install pwgen htop sysstat dstat iotop vim molly-guard unattended-upgrades screen git mtr

# update all the things
/bin/echo "Applying all system updates"
/usr/bin/sudo DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

# now we clean up left over packages
/bin/echo "cleaning out old packages that are no longer required"
/usr/bin/sudo /usr/bin/apt-get -y auto-remove

# and then restart
/bin/echo "restarting"
/usr/bin/sudo init 6
