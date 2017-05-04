# TODO

## general
- when a login occurs it should notify you if there are updates pending for pip, brew etc like apt does on Linux.
- Find a way to keep my configs synced across machines for some apps.
  - atom (packages and configs)
  - git (config)
  - ssh (keys and auth keys)
- create a windows-desktop-build.ps1

## dotfiles
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
  - New packages: mtr
  - ***BUGS***

- **macOS**
  - Build base OS deploy script:
  See: http://burnedpixel.com/blog/beginners-setup-guide-for-ruby-node-git-github-on-your-mac/ &
    - make sure all the binaries are fully and properly pathed
    - build script should prompt for name and email address to use with github.
  - Base OS Customisations:
    - disable siri (need to do from CLI) See: https://apple.stackexchange.com/questions/258816/how-to-completely-disable-siri-on-sierra
  - New alias: StartApps (runs all my default apps)
  - New brew packages: mtr, vlc
  - Review the script at https://github.com/andrew-best-diaxion/shell-scripts/blob/master/setupScripts/newMacSetup.sh and see what other smarts I can use in my script.
  - New Finder configs:
    `nil`


## ssh
- See https://github.com/natelandau/shell-scripts/blob/master/setupScripts/newMacSetup.sh
  - It has a good function for SSH init.

# DONE
- YYYYMMDD - {ITEM}
- 20170306 - - setup \_awsAliases - \_awsAliases should have a sanity check to be sure aws cli is installed
- 20170306 - configure aws_completer if AWS CLI is installed.
- 20170306 - the makesymlinks.sh should only set up \_awsAliases if the AWS CLI is installed and - only if the AWS credentials file exists.
- 20170303 - set git creds
