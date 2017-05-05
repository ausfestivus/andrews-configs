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

# install git
brew install git

# configure git identification
# Set your username
git config --global user.name "Andrew Best"

# Set your email address
git config --global user.email "festivus@gmail.com"

# configure git to use the osxkeychain auth helper
git config --global credential.helper osxkeychain

# the above article this is based on says to now configure SSH keys for use
# with github. We wont be using ssh with github.

# TODO
# placeholder for download and install of other standard apps
# dotfiles, github client, atom, atom packages, 1password, chrome, MS Office, Skype For Business,  Things, Slack, Tweetbot, VMware Fusion, VLC,
