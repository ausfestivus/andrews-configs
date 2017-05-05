# TODO

## general
- when a login occurs it should notify you if there are updates pending for pip, brew etc like apt does on Linux.
- Find a way to keep my configs synced across machines for some apps.
  - atom (packages and configs)
  - git (config)
  - ssh (keys and auth keys)
- create a windows-desktop-build.ps1

## dotfiles
- ~~MacOS: Need to make sure that /usr/local/sbin is in the path (for mtr in Brew)~~
- make sure all the binaries are fully and properly pathed
- better error/sanity checks in makesymlinks.sh
- allow makesymlinks.sh to keep X copies of older dotfiles.
- makesymlinks.sh should only update dotfiles which are newer
- need to work out how to bring AWS creds over safely (part of host build?)
- more power to the profile
  - http://tldp.org/LDP/abs/html/sample-bashrc.html
  - more bash profile examples: https://gist.github.com/paulocheque/3667381

## hostbuild
- **Linux**
  - See: https://confluence.diaxion.com/display/~abest/Ubuntu+Dev+VM+Build
  - In paragraph `# Disable guest access` we need to do a sanity check that we have a GUI installed.
  - New packages: mtr
  - ***BUGS***

- **macOS** Build base OS deploy script:

  See: http://burnedpixel.com/blog/beginners-setup-guide-for-ruby-node-git-github-on-your-mac/
  - Install python3 and pip http://python-guide-pt-br.readthedocs.io/en/latest/starting/install3/osx/
  - make sure all the binaries are fully and properly pathed
  - build script should prompt for name and email address to use with github.
  - Base OS Customisations:
    - disable siri (need to do from CLI) See: https://apple.stackexchange.com/questions/258816/how-to-completely-disable-siri-on-sierra  
  - New apps: vlc
  - New brew packages: mtr, python3 (which will also give you pip3)
  - New pip3 packages: beautysh (required by atom-beautify package)
  - How do we best handle pip3 updates?

```
Pip, setuptools, and wheel have been installed. To update them
  pip3 install --upgrade pip setuptools wheel

You can install Python packages with
  pip3 install <package>

They will install into the site-package directory
  /usr/local/lib/python3.6/site-packages

See: http://docs.brew.sh/Homebrew-and-Python.html
```    

  - Review the script at https://github.com/andrew-best-diaxion/shell-scripts/blob/master/setupScripts/newMacSetup.sh and see what other smarts I can use in my script.
  - New Finder configs:
  - ~~New alias: StartApps (runs all my default apps)~~ WONTFIX


## ssh
- See https://github.com/natelandau/shell-scripts/blob/master/setupScripts/newMacSetup.sh
  - It has a good function for SSH init.

# DONE
- YYYYMMDD - {ITEM}
- 20170306 - - setup \_awsAliases - \_awsAliases should have a sanity check to be sure aws cli is installed
- 20170306 - configure aws_completer if AWS CLI is installed.
- 20170306 - the makesymlinks.sh should only set up \_awsAliases if the AWS CLI is installed and - only if the AWS credentials file exists.
- 20170303 - set git creds
