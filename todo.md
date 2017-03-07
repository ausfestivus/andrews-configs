# TODO
- when a login occurs it should notify you if there are updates pending for pip like apt does on Linux.

## dotfiles
- better error/sanity checks in makesymlinks.sh
- allow makesymlinks.sh to keep X copies of older dotfiles.
- makesymlinks.sh should only update dotfiles which are newer
- need to work out how to bring AWS creds over safely (part of host build?)
- more power to the profile
  - http://tldp.org/LDP/abs/html/sample-bashrc.html
  - more bash profile examples: https://gist.github.com/paulocheque/3667381

## hostbuild
- Linux
  - See: https://confluence.diaxion.com/display/~abest/Ubuntu+Dev+VM+Build
  - ***BUGS***
    - 
- macOS
  - See: http://burnedpixel.com/blog/beginners-setup-guide-for-ruby-node-git-github-on-your-mac/


## ssh

# DONE
- YYYYMMDD - {ITEM}
- 20170306 - - setup \_awsAliases - \_awsAliases should have a sanity check to be sure aws cli is installed
- 20170306 - configure aws_completer if AWS CLI is installed.
- 20170306 - the makesymlinks.sh should only set up \_awsAliases if the AWS CLI is installed and - only if the AWS credentials file exists.
- 20170303 - set git creds
