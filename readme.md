# andrews-configs
Bringing all my dotfiles other assorted config files into github.
Based on http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
See **Credits** below for additional contributed code.

## Introduction
This repo contains my configurations for various parts of unixy systems. it includes:
* dotfiles - a method of quickly building my terminal environments on macOS and Linux machines.
* hostbuild - scripts which allow me to quickly setup a macOS or Linux host quickly.
* terraform - terraform used to build my CSP services.
* ~~ssh - my ssh configurations~~

## Installation
To start using these on one of my machines:
- ensure you have the CLI github token (see password safe)
- be the user on the target machine (not root)
- be in the user homedir (not root)
- run `git clone https://github.com/ausfestivus/andrews-configs.git`
- enter username and access token
- run `~/andrews-configs/dotfiles/makesymlinks.sh`

To compare your local clone with the master branch:
- be in the ~/andrews-configs dir `cd ~andrews-configs`
- run `git status`

To update from master:
- be in the ~/andrews-configs dir `cd ~andrews-configs`
- run `git pull origin master`
- run `~/andrews-configs/dotfiles/makesymlinks.sh`

## TODO
See https://github.com/ausfestivus/andrews-configs/issues

## Contributing
Currently closed.

## History
See: https://github.com/ausfestivus/andrews-configs/commits/master

## Credits
See: https://github.com/ausfestivus/andrews-configs/graphs/contributors

Sites which had contributing examples:

***dotfiles:***
* Best practice for shell profile dotfiles on macOS: http://stackoverflow.com/questions/4493063/best-practice-for-bash-start-up-files-on-a-mac
* Ubuntu Set User Profile Under Bash Shell: https://www.cyberciti.biz/faq/ubuntu-linux-user-profile-bash-configuration/

***bash:***
* http://kvz.io/blog/2013/11/21/bash-best-practices/
* Also loosely based on https://github.com/natelandau/shell-scripts
* and http://stefaanlippens.net/bashrc_and_others/
* and https://linux.die.net/Bash-Beginners-Guide/sect_03_01.html (nice intro to the shell files and their operating order)
* and http://stackoverflow.com/questions/415403/whats-the-difference-between-bashrc-bash-profile-and-environment
* and http://stackoverflow.com/questions/908537/if-bash-profile-usually-source-bashrc-any-way-why-not-just-use-bashrc

***build***
* Python on MacOS install: http://python-guide-pt-br.readthedocs.io/en/latest/starting/install3/osx/

## License
Not licensed for use by anyone.
Do not use.
