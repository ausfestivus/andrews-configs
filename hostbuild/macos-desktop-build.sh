#!/bin/bash

# configure our base Mac OS machine
# based on http://burnedpixel.com/blog/beginners-setup-guide-for-ruby-node-git-github-on-your-mac/

# install xcode tools
/usr/bin/xcode-select --install

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Press return
brew doctor

# the above article this is based on says to manipulate the PATH var here.
# going to ignore that for now as all our PATH stuff occurs via the dotfiles
# scripts.

# install brew packages
brew install git mtr python3 aws-shell git openssl shellcheck awscli sqlite gdbm nmap readline xz ssh-copy-id wget

# configure git identification
input "Please enter your full name for Github global config eg Fred Nurk: "
read githubusername
input "Please enter the email address you use with your Github account: "
read githubemail
echo ""
git config --global user.name $githubusername # Set your user name
git config --global user.email $githubemail # Set your email address
git config --global credential.helper osxkeychain # configure git to use the osxkeychain auth helper

# pip3 apps
pip3 install beautysh

# Other apps:
# Github desktop
if [[ ! -e "/Applications/GitHub Desktop.app" ]]; then # If the desktop app is not installed
  # Download it and install it.
  wget -O ~/Downloads/GithubDesktop.zip https://central.github.com/mac/latest && /
  unzip ~/Downloads/GithubDesktop.zip -d /Applications
fi

# Google Chrome
if [[ ! -e "/Applications/Google Chrome.app/" ]]; then
  wget -O ~/Downloads/googlechrome.dmg https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg && /

fi
https://www.google.com.au/chrome/browser/desktop/



# Appstore apps
