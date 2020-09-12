#!/usr/bin/env bash

#
# This script does the following:
#
# * sets up the necessary directories
# * pulls the necessary files
# * runs the build

function doTheNeedful { # Our main.
  # invoke verbose usage when set
  if ${verbose}; then v="-v" ; fi
  
  # Work out what OS we're running only
  detectOS
}

## SET SCRIPTNAME VARIABLE ##
scriptName=$(basename "$0")

function detectOS {
    if  [[ "$OSTYPE" =~ ^darwin ]] ; then
      # macOS specific commands go here
      echo "Hi, im a Mac and my name is '$HOSTNAME'"
      #
      echo "Building Mac OS environment."
      #bash -c "$(wget -O - https://raw.githubusercontent.com/ausfestivus/andrews-configs/develop/hostbuild/macos-desktop-build.sh)"
      curl -sL https://raw.githubusercontent.com/ausfestivus/andrews-configs/ausfestivus/issue73/hostbuild/macos-desktop-build.sh | bash
      #
      echo "Installing shell customisations."
      cd ~ && git clone https://github.com/ausfestivus/andrews-configs.git
      ~/andrews-configs/dotfiles/makesymlinks.sh
    elif [ "$OSTYPE" == "linux-gnu" ] ; then
      # Linux specific commands go here
      echo "Hi, im a Linux machine and my name is '$HOSTNAME'"
      curl -sL https://raw.githubusercontent.com/ausfestivus/andrews-configs/develop/hostbuild/cloud-jumphost-build.sh | bash
      exit 1
      # TODO
      # detect a Windows machine?
      # Couldnt work it out. Die.
    else
      echo "No idea what you ran me on."
      exit 1
    fi
}

function safeExit() {
  # safeExit
  # -----------------------------------
  # Non destructive exit for when script exits naturally.
  # Usage: Add this function at the end of every script.
  # -----------------------------------
  # Delete temp files, if any
  if [ -d "${tmpDir}" ] ; then
    rm -r "${tmpDir}"
  fi
  trap - INT TERM EXIT
  exit
}

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`, for example.
set -o pipefail

# Run your script
doTheNeedful

# Exit cleanly
safeExit