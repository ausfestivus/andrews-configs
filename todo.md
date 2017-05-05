# TODO

## general
- when a login occurs it should notify you if there are updates pending for pip brew etc like apt does on Linux.
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


- **macOS** Build base OS deploy script:

  See: http://burnedpixel.com/blog/beginners-setup-guide-for-ruby-node-git-github-on-your-mac/
  - ~~Install python3 and pip http://python-guide-pt-br.readthedocs.io/en/latest/starting/install3/osx/~~
  - ~~build script should prompt for name and email address to use with github.~~
  - Switch over to using `brew cask` for other packages.
  - make sure all the binaries are fully and properly pathed
  - App Store Apps:
    Things Slack Scapple Tweetbot "Microsoft Remote Desktop"
  - New apps: Chrome "Github Client" 1password Things Atom "Atom Packages" "VMware Fusion" VLC
    - Chrome https://www.google.com.au/chrome/browser/desktop/#
    - ~~Github Client: https://central.github.com/mac/latest~~
    - Atom https://atom.io/download/mac
    - 1password https://app-updates.agilebits.com/download/OPM4
    - VLC http://get.videolan.org/vlc/2.2.4/macosx/vlc-2.2.4.dmg
  - Atom Packages:
```
Community Packages (18) /Users/andrew/.atom/packages
├── atom-autocomplete-php@0.22.2
├── atom-beautify@0.29.23
├── atom-cform@0.6.0
├── atom-ternjs@0.18.3
├── autocomplete-json@5.4.0
├── autocomplete-python@1.8.63
├── broadcast@0.4.0
├── busy-signal@1.4.1
├── git-plus@7.8.0
├── intentions@1.1.2
├── language-csv@1.1.2
├── language-powershell@4.0.0
├── linter@2.1.4
├── linter-jscs@4.1.2
├── linter-jsonlint@1.3.0
├── linter-shellcheck@1.4.4
├── linter-ui-default@1.2.4
└── script@3.14.1
```
  - Base OS Customisations:
    - disable siri (need to do from CLI) See: https://apple.stackexchange.com/questions/258816/how-to-completely-disable-siri-on-sierra
    - desktop change
    - screen saver setup (and image contents)
    - dotfiles (download script and execute)
  - How do we do a CLI download and install of Office for Mac and SfB?
  - How do we do a CLI download and install of VMware Fusion?
  - Review the script at https://github.com/andrew-best-diaxion/shell-scripts/blob/master/setupScripts/newMacSetup.sh and see what other smarts I can use in my script.
  - How do we best handle pip3 updates?
  - New Finder configs: `none current`
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
