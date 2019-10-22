#!/usr/bin/env bash

# ##################################################
#
version="1.0.2"              # Sets version variable
#
# HISTORY:
#
# * 2017-05-05 - v1.0.1  - Updated by Andrew Best
# * 2016-04-19 - v1.0.0  - First Creation
#
# ##################################################

function mainScript() {
  # invoke verbose usage when set
  if ${verbose}; then v="-v" ; fi

  # Helper Functions
  # ###################
  function preflights() {
    # Preflight checks that must be successful for the script to run further. Checks are:
    # 1. Signed into to iCloud
    # 2. Signed into App Store
    true
  }
  function isAppInstalled() {
    # Feed this function either the bundleID (com.apple.finder) or a name (finder) for a native
    # mac app and it will determine whether it is installed or not
    #
    # usage: if isAppInstalled 'finder' &>/dev/null; then ...
    #
    # http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os

    local appNameOrBundleId="$1" isAppName=0 bundleId
    # Determine whether an app *name* or *bundle ID* was specified.
    [[ $appNameOrBundleId =~ \.[aA][pP][pP]$ || $appNameOrBundleId =~ ^[^.]+$ ]] && isAppName=1
    if (( isAppName )); then # an application NAME was specified
      # Translate to a bundle ID first.
      bundleId=$(osascript -e "id of application \"$appNameOrBundleId\"" 2>/dev/null) ||
      { echo "$FUNCNAME: ERROR: Application with specified name not found: $appNameOrBundleId" 1>&2; return 1; }
    else # a BUNDLE ID was specified
      bundleId=$appNameOrBundleId
    fi
    # Let AppleScript determine the full bundle path.
    osascript -e "tell application \"Finder\" to POSIX path of (get application file id \"$bundleId\" as alias)" 2>/dev/null ||
    { echo "$FUNCNAME: ERROR: Application with specified bundle ID not found: $bundleId" 1>&2; return 1; }
  }
  function brewMaintenance () {
    # brewMaintenance
    # ------------------------------------------------------
    # Will run the recommended Homebrew maintenance scripts
    # ------------------------------------------------------
    seek_confirmation "Run Homebrew maintenance?"
    if is_confirmed; then
      brew doctor
      brew update
      brew upgrade
    fi
  }
  function brewCleanup () {
    # This function cleans up an initial Homebrew installation

    notice "Running Homebrew maintenance..."

    # This is where brew stores its binary symlinks
    binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

    if [[ "$(type -P ${binroot}/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
      info "Adding ${binroot}/bash to the list of acceptable shells"
      echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
    fi
    if [[ "$SHELL" != "${binroot}/bash" ]]; then
      info "Making ${binroot}/bash your default shell"
      sudo chsh -s "${binroot}/bash" "$USER" >/dev/null 2>&1
      success "Please exit and restart all your shells."
    fi

    brew cleanup

    # if brew cask > /dev/null; then
    #   brew cask cleanup
    # fi
  }
  function doInstall () {
    # Reads a list of items, checks if they are installed, installs
    # those which are needed.
    #
    # Variables needed are:
    # LISTINSTALLED:  The command to list all previously installed items
    #                 Ex: "brew list" or "gem list | awk '{print $1}'"
    #
    # INSTALLCOMMAND: The Install command for the desired items.
    #                 Ex:  "brew install" or "gem install"
    #
    # RECIPES:      The list of packages to install.
    #               Ex: RECIPES=(
    #                     package1
    #                     package2
    #                   )
    #
    # Credit: https://github.com/cowboy/dotfiles

    function to_install() {
      local desired installed i desired_s installed_s remain
      # Convert args to arrays, handling both space- and newline-separated lists.
      read -ra desired < <(echo "$1" | tr '\n' ' ')
      read -ra installed < <(echo "$2" | tr '\n' ' ')
      # Sort desired and installed arrays.
      unset i; while read -r; do desired_s[i++]=$REPLY; done < <(
        printf "%s\n" "${desired[@]}" | sort
      )
      unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
        printf "%s\n" "${installed[@]}" | sort
      )
      # Get the difference. comm is awesome.
      unset i; while read -r; do remain[i++]=$REPLY; done < <(
        comm -13 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
      )
      echo "${remain[@]}"
    }

    function checkInstallItems() {
      # If we are working with 'cask' we need to dedupe lists
      # since apps might be installed by hand
      if [[ $INSTALLCOMMAND =~ cask ]]; then
        if isAppInstalled "${item}" &>/dev/null; then
          return
        fi
      fi
      # If we installing from mas (mac app store), we need to dedupe the list AND
      # sign in to the app store
      if [[ $INSTALLCOMMAND =~ mas ]]; then
        # Lookup the name of the application being installed
        appName="$(curl -s https://itunes.apple.com/lookup?id=$item | jq .results[].trackName)"
        if isAppInstalled "${appName}" &> /dev/null; then
          return
        fi
        # Tell the user the name of the app
        notice "$item --> $appName"
      fi
    }

    # Log in to the Mac App Store if using mas
    if [[ $INSTALLCOMMAND =~ mas ]]; then
      ##
      # mas signin with MFA doesnt work.
      # ISSUE https://github.com/ausfestivus/andrews-configs/issues/1
      #mas signin $macStoreUsername "$macStorePass"
      # WORKAROUND from https://github.com/mas-cli/mas/issues/164
      # sign into the app store manually before running this.
      # mas signout
      # input "Please enter your Mac app store username: "
      # read macStoreUsername
      # input "Please enter your Mac app store password: "
      # read -s macStorePass
      # echo ""
      ##
      open -a /Applications/App\ Store.app

    fi

    list=($(to_install "${RECIPES[*]}" "$(${LISTINSTALLED})"))

    if [ ${#list[@]} -gt 0 ]; then
      seek_confirmation "Confirm each package before installing?"
      if is_confirmed; then
        for item in "${list[@]}"; do
          checkInstallItems
          seek_confirmation "Install ${item}?"
          if is_confirmed; then
            notice "Installing ${item}"
            ## FFMPEG takes additional flags
            #if [[ "${item}" = "ffmpeg" ]]; then
            #  installffmpeg
            #  elif [[ "${item}" = "tldr" ]]; then
            #  brew tap tldr-pages/tldr
            #  brew install tldr
            #else
            ${INSTALLCOMMAND} "${item}"
            #fi
          fi
        done
      else
        for item in "${list[@]}"; do
          checkInstallItems
          notice "Installing ${item}"
          ## FFMPEG takes additional flags
          #if [[ "${item}" = "ffmpeg" ]]; then
          #  installffmpeg
          #  elif [[ "${item}" = "tldr" ]]; then
          #  brew tap tldr-pages/tldr
          #  brew install tldr
          #else
          ${INSTALLCOMMAND} "${item}"
          #fi
        done
      fi
    fi
  }
  # Installation Commands
  # ###################
  function installCommandLineTools() {
    notice "Checking for Command Line Tools..."

    if [[ ! "$(type -P gcc)" || ! "$(type -P make)" ]]; then
      #local osx_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')
      local cmdLineToolsTmp="${tmpDir}/.com.apple.dt.CommandLineTools.installondemand.in-progress"

      # Create the placeholder file which is checked by the software update tool
      # before allowing the installation of the Xcode command line tools.
      touch "${cmdLineToolsTmp}"

      # Find the last listed update in the Software Update feed with "Command Line Tools" in the name
      cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | tail -1 | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)

      softwareupdate -i "${cmd_line_tools}" -v

      # Remove the temp file
      if [ -f "${cmdLineToolsTmp}" ]; then
        rm ${v} "${cmdLineToolsTmp}"
      fi
    fi
    success "Command Line Tools installed"
  }
  function installHomebrew () {
    # Check for Homebrew
    notice "Checking for Homebrew..."
    if [ ! "$(type -P brew)" ]; then
      notice "No Homebrew. Gots to install it..."
      #   Ensure that we can actually, like, compile anything.
      if [[ ! $(type -P gcc) && "$OSTYPE" =~ ^darwin ]]; then
        notice "XCode or the Command Line Tools for XCode must be installed first."
        installCommandLineTools
      fi
      # Check for Git
      if [ ! "$(type -P git)" ]; then
        notice "XCode or the Command Line Tools for XCode must be installed first."
        installCommandLineTools
      fi
      # Install Homebrew
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      installHomebrewTaps
    fi
    success "Homebrew installed"
  }
  function checkTaps() {

    verbose "Confirming we have required Homebrew taps"
    if ! brew cask help &>/dev/null; then
      installHomebrewTaps
    fi
    if [ ! "$(type -P mas)" ]; then
      installHomebrewTaps
    fi
  }
  function installHomebrewTaps() {
    #brew tap homebrew/dupes
    #brew tap homebrew/versions
    brew tap homebrew/cask-cask   
    #brew tap caskroom/fonts
    #brew tap caskroom/versions # Subversion client for MacOS
  }
  function installXcode() {
    notice "Checking for XCode..."
    if ! isAppInstalled 'xcode' &>/dev/null; then
      unset LISTINSTALLED INSTALLCOMMAND RECIPES

      checkTaps

      LISTINSTALLED="mas list"
      INSTALLCOMMAND="mas install"
      RECIPES=(
        497799835 #xCode
      )
      doInstall

      # we also accept the license
      sudo xcodebuild -license accept
    fi
    success "XCode installed"
  }
  function installDropbox () {
    # This function checks for Dropbox being installed.
    # If it is not found, we install it and its prerequisites
    notice "Checking for Dropbox..."

    checkTaps

    if ! isAppInstalled 'Dropbox' &>/dev/null; then
      unset LISTINSTALLED INSTALLCOMMAND RECIPES
      LISTINSTALLED="brew cask list"
      INSTALLCOMMAND="brew cask install --appdir=/Applications"
      RECIPES=(
        dropbox
      )
      doInstall
      open -a dropbox
    fi

    success "Dropbox installed"
  }
  function installffmpeg () {

    notice "Checking for ffmpeg...."
    # My preferred install of ffmpeg
    if [ ! $(type -P "ffmpeg") ]; then
      brew install ffmpeg --with-faac --with-fdk-aac --with-ffplay --with-fontconfig --with-freetype --with-libcaca --with-libass --with-frei0r --with-libass --with-libbluray --with-libcaca --with-libquvi --with-libvidstab --with-libsoxr --with-libssh --with-libvo-aacenc --with-libvidstab --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-openssl --with-opus --with-rtmpdump --with-schroedinger --with-speex --with-theora --with-tools --with-webp --with-x265
    fi

    success "Done ffmpeg installed"
  }
  function installCaskApps() { # Install apps regardless of physical or virtual machine.
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    notice "Checking for casks to install..."

    checkTaps

    LISTINSTALLED="brew cask list"
    INSTALLCOMMAND="brew cask install --appdir=/Applications"
    # The recipe list we use depends on if we're in a VM or not.
    # eg we dont want to install a virtualisation engine if we're in VMware Fusion.
    # Start by pulling and storing the manufacturer info
    isVMware=""
    isVMware=$(ioreg -l | grep -e "\"manufacturer\" \= <\"VMware, Inc.\">" 2>/dev/null)
    # Choose which recipe list to use if were a VM or not.
    if [[ $isVMware == *VMware* ]]; then
      # we are a VM
      notice "Virtual Machine Detected. Not installing virtualisation engines..."
      RECIPES=(
        1password
        github
        google-chrome
        microsoft-teams
        slack
        vlc
        xmind
      )
    else
      # we are NOT a VM.
      notice "Physical Machine Detected. Installing virtualisation engines..."
      RECIPES=(
        1password
        github
        google-chrome
        microsoft-teams
        slack
        vlc
        xmind
        vmware-fusion
      ) 
    fi

    # for item in "${RECIPES[@]}"; do
    #   info "$item"
    # done
    doInstall

    success "Done installing cask apps"
  }
  function installAppStoreApps() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    notice "Checking for App Store apps to install..."

    checkTaps

    LISTINSTALLED="mas list"
    INSTALLCOMMAND="mas install"
    RECIPES=(
      405399194 # Kindle (1.21.1)
      1278508951 # Trello (2.10.2)
      425424353 # The Unarchiver (3.11.3)
      1189824719 # Jayson (1.8.1)
      823766827 # OneDrive (17.3.7131)
      1091189122 # Bear (1.4.1)
      443823264 # FindSpace (1.0.0)
      557168941 # Tweetbot (2.5.4)
      568020055 # Scapple (1.30.1)
      585829637 # Todoist (7.1.1)
    )
    doInstall

    success "Done installing app store apps"
  }
  function installDevApps() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    notice "Checking for dev apps to install"

    checkTaps

    LISTINSTALLED="brew cask list"
    INSTALLCOMMAND="brew cask install --appdir=/Applications"
    RECIPES=(
      charles
      codekit
      github
      imagealpha
      imageoptim
      java
      kaleidoscope
      licecap # Movie screen captures
      mamp # mac-based LAMP development stack
      paw # REST IDE
      tower # Mac GUI for git
    )

    # for item in "${RECIPES[@]}"; do
    #   info "$item"
    # done
    doInstall

    success "Done installing dev apps"
  }
  function installHomebrewPackages() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    notice "Checking for Homebrew packages to install..."

    checkTaps

    LISTINSTALLED="brew list"
    INSTALLCOMMAND="brew install"

    RECIPES=(
      # autoconf
      # automake
      bash
      bash-completion
      # colordiff
      # coreutils
      # ffmpeg
      # gifsicle
      git
      # git-extras
      # git-flow
      # hub
      # hr
      # id3tool
      # imagemagick
      # jpegoptim
      jq
      # lesspipe
      # libksba
      # libtool
      # libyaml
      # mackup
      # man2html
      mas
      mtr
      # multimarkdown
      nmap
      # node
      # openssl
      # optipng
      # pkg-config
      # pngcrush
      # p7zip
      # readline
      # rename
      shellcheck          # Bash linter
      # sl
      # source-highlight
      # ssh-copy-id
      # sqlite
      # tag
      terminal-notifier
      # tldr                # Better man pages
      # tree
      # unison              # Rsynch like tool
      wget
      awscli
      aws-shell
      azure-cli
      python3
    )
    doInstall

    success "Done installing Homebrew packages"
  }
  function installRuby() {

    notice "Checking for RVM (Ruby Version Manager)..."

    local RUBYVERSION="2.1.2" # Version of Ruby to install via RVM

    # Check for RVM
    if [ ! "$(type -P rvm)" ]; then
      seek_confirmation "Couldn't find RVM. Install it?"
      if is_confirmed; then
        curl -L https://get.rvm.io | bash -s stable
        source "${HOME}/.rvm/scripts/rvm"
        source "${HOME}/.bash_profile"
        #rvm get stable --autolibs=enable
        rvm install ${RUBYVERSION}
        rvm use ${RUBYVERSION} --default
      fi
    fi

    success "RVM and Ruby are installed"
  }
  function installRubyGems() {
    unset LISTINSTALLED INSTALLCOMMAND RECIPES

    notice "Checking for Ruby gems..."

    LISTINSTALLED="gem list | awk '{print $1}'"
    INSTALLCOMMAND="gem install"

    RECIPES=(
      bundler
      classifier
      compass
      digest
      fileutils
      jekyll
      kramdown
      kss
      less
      logger
      mini_magick
      rake
      reduce
      s3_website
      sass
      smusher
    )

    doInstall

    success "Done installing Ruby Gems"
  }
  function configureSSH() {
    notice "Configuring SSH"

    info "Checking for SSH key in ~/.ssh/id_rsa.pub, generating one if it doesn't exist"
    [[ -f "${HOME}/.ssh/id_rsa.pub" ]] || ssh-keygen -t rsa

    info "Copying public key to clipboard"
    [[ -f "${HOME}/.ssh/id_rsa.pub" ]] && cat "${HOME}/.ssh/id_rsa.pub" | pbcopy

    # Add SSH keys to Github
    seek_confirmation "Add SSH key to Github?"
    if is_confirmed; then
      info "Paste the key into Github"

      open https://github.com/account/ssh

      seek_confirmation "Test Github Authentication via ssh?"
      if is_confirmed; then
        info "Note that even when successful, this will fail the script."
        ssh -T git@github.com
      fi
    fi

    success "SSH Configured"
  }
  function configureMackup() {
    notice "Running mackup config..."

    local DIRCFG="${HOME}/Dropbox/sharedConfiguration/Mackup"

    #installDropbox

    dropboxFilesTest=(
      "Dropbox/sharedConfiguration/Mackup/Library/Application Support/PaxGalaxia/net.txt"
      "Dropbox/sharedConfiguration/Mackup/Pictures/DeviantartBackup/clouds2.jpg"
      "Dropbox/sharedConfiguration/Mackup/Library/init/bash/aliases.bash"
      "Dropbox/sharedConfiguration/Mackup/.mackup/my-files.cfg"
      "Dropbox/sharedConfiguration/App Configuration Files/Alfred2/Alfred.alfredpreferences"
      "Dropbox/sharedConfiguration/Mackup/Library/Preferences/com.dustinrue.ControlPlane.plist"
    )

    info "Confirming that Dropbox has synced by looking for files..."
    info "(This might fail if the list of files is out of date)"

    for dropboxFile in "${dropboxFilesTest[@]}"; do
      verbose "Checking: $dropboxFile"
      while [ ! -e "${HOME}/${dropboxFile}" ]; do
        info "  Waiting for Dropbox to Sync files..."
        sleep 10
      done
    done

    #Add some additional time just to be sure....
    for ((i=1; i<=6; i++)); do
      info "  Waiting for Dropbox to Sync files..."
      sleep 10
    done

    # Sync Complete
    success "Dropbox has synced"

    # Confirm Mackup exists
    if [ ! "$(type -P mackup)" ]; then
      installHomebrew
      brew install mackup
    fi

    notice "Checking for Mackup config files..."
    if [ ! -L "${HOME}/.mackup" ]; then
      info "Symlinking ~/.mackup"
      ln -s "${MACKUPDIR}/.mackup" "${HOME}/.mackup"
    else
      verbose "${HOME}/.mackup is symlinked"
    fi
    if [ ! -L "${HOME}/.mackup.cfg" ]; then
      info "Symlinking ~/.mackup.cfg"
      ln -s "${MACKUPDIR}"/.mackup.cfg "${HOME}"/.mackup.cfg
    else
      verbose "~${HOME}.mackup.cfg is symlinked"
    fi
    success "Mackup config files are symlinked"

    seek_confirmation "Run Mackup Restore?"
    if is_confirmed; then
      mackup restore
    fi
  }
  function instappPip3packages() { 
  }
  function installPip3() {
    # Function for install of some required pip3 packages.
    # See #25
    # Check for pip3
    notice "Checking for pip3..."
    if [ ! "$(type -P pip3)" ]; then
      # pip3 binary not found.
      notice "pip3 is not installed. Installing it..."
    fi

  }
  function installSundry() {
    # a catch all function to act as a hook for other sundry
    # installations and configurations.
    notice "Installing sundry items..."
    info "  Installing homebrew-notifier..."
    [[ -f "${HOME}/.homebrew-notifier/notifier.sh" ]] || curl -fsS https://raw.githubusercontent.com/grantovich/homebrew-notifier/master/install.sh | sh
    success "  homebrew-notifier installed."
    # check for existence of ~/bin
    info "  Creating ${HOME}/bin if it doesnt exist..."
    [[ -d "${HOME}/bin" ]] || mkdir "${HOME}/bin"
    success "  ${HOME}/bin created."
    # install some of our scripts
  }
  # ###################
  # Run the script
  # ###################

  # Ask for the administrator password upfront
  echo "administrator authorisation required. Please enter your administrator password."
  sudo -v

  installCommandLineTools
  installHomebrew
  checkTaps
  brewCleanup
  installHomebrewPackages
  installCaskApps
  #installXcode
  #installDropbox
  installAppStoreApps
  #installDevApps
  #installRuby
  #installRubyGems
  #configureSSH
  #configureMackup
  #installPip3
  installSundry
}

## SET SCRIPTNAME VARIABLE ##
scriptName=$(basename "$0")

function trapCleanup() {
  # trapCleanup Function
  # -----------------------------------
  # Any actions that should be taken if the script is prematurely
  # exited.  Always call this function at the top of your script.
  # -----------------------------------
  echo ""
  # Delete temp files, if any
  if [ -d "${tmpDir}" ] ; then
    rm -r "${tmpDir}"
  fi
  die "Exit trapped."
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

function seek_confirmation() {
  # Asks questions of a user and then does something with the answer.
  # y/n are the only possible answers.
  #
  # USAGE:
  # seek_confirmation "Ask a question"
  # if is_confirmed; then
  #   some action
  # else
  #   some other action
  # fi
  #
  # Credt: https://github.com/kevva/dotfiles
  # ------------------------------------------------------

  input "$@"
  if ${force}; then
    notice "Forcing confirmation with '--force' flag set"
  else
    read -p " (y/n) " -n 1
    echo ""
  fi
}

function is_confirmed() {
  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

function is_not_confirmed() {
  if [[ "${REPLY}" =~ ^[Nn]$ ]]; then
    return 0
  fi
  return 1
}

# Set Flags
# -----------------------------------
# Flags which can be overridden by user input.
# Default values are below
# -----------------------------------
quiet=false
printLog=false
verbose=false
force=false
strict=false
debug=false
args=()

# Set Temp Directory
# -----------------------------------
# Create temp directory with three random numbers and the process ID
# in the name.  This directory is removed automatically at exit.
# -----------------------------------
tmpDir="/tmp/${scriptName}.$RANDOM.$RANDOM.$RANDOM.$$"
(umask 077 && mkdir "${tmpDir}") || {
  die "Could not create temporary directory! Exiting."
}

# Logging
# -----------------------------------
# Log is only used when the '-l' flag is set.
#
# To never save a logfile change variable to '/dev/null'
# Save to Desktop use: $HOME/Desktop/${scriptName}.log
# Save to standard user log location use: $HOME/Library/Logs/${scriptName}.log
# -----------------------------------
logFile="${HOME}/Library/Logs/${scriptName}.log"


# Options and Usage
# -----------------------------------
# Print usage
usage() {
  echo -n "${scriptName} [OPTION]... [FILE]...

This is a script template.  Edit this description to print help to users.

 ${bold}Options:${reset}
  -u, --username    Username for script
  -p, --password    User password
  --force           Skip all user interaction.  Implied 'Yes' to all actions.
  -q, --quiet       Quiet (no output)
  -l, --log         Print log to file
  -s, --strict      Exit script with null variables.  i.e 'set -o nounset'
  -v, --verbose     Output more information. (Items echoed to 'verbose')
  -d, --debug       Runs script in BASH debug mode (set -x)
  -h, --help        Display this help and exit
      --version     Output version information and exit
  "
}

# Iterate over options breaking -ab into -a -b when needed and --foo=bar into
# --foo bar
optstring=h
unset options
while (($#)); do
  case $1 in
      # If option is of type -ab
    -[!-]?*)
      # Loop over each character starting with the second
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}

        # Add current char to options
        options+=("-$c")

        # If option takes a required argument, and it's not the last char make
        # the rest of the string its argument
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;

      # If option is of type --foo=bar
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
      # add --endopts for --
    --) options+=(--endopts) ;;
      # Otherwise, nothing special
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

# Print help if no arguments were passed.
# Uncomment to force arguments when invoking the script
# -------------------------------------
# [[ $# -eq 0 ]] && set -- "--help"

# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; safeExit ;;
    --version) echo "$(basename $0) ${version}"; safeExit ;;
    -u|--username) shift; username=${1} ;;
    -p|--password) shift; echo "Enter Pass: "; stty -echo; read PASS; stty echo;
      echo ;;
    -v|--verbose) verbose=true ;;
    -l|--log) printLog=true ;;
    -q|--quiet) quiet=true ;;
    -s|--strict) strict=true ;;
    -d|--debug) debug=true ;;
    --force) force=true ;;
    --endopts) shift; break ;;
    *) die "invalid option: '$1'." ;;
  esac
  shift
done

# Store the remaining part as arguments.
args+=("$@")


# Logging and Colors
# -----------------------------------------------------
# Here we set the colors for our script feedback.
# Example usage: success "sometext"
#------------------------------------------------------

# Set Colors
bold=$(tput bold)
reset=$(tput sgr0)
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)
underline=$(tput sgr 0 1)

function _alert() {
  if [ "${1}" = "emergency" ]; then local color="${bold}${red}"; fi
  if [ "${1}" = "error" ]; then local color="${bold}${red}"; fi
  if [ "${1}" = "warning" ]; then local color="${red}"; fi
  if [ "${1}" = "success" ]; then local color="${green}"; fi
  if [ "${1}" = "debug" ]; then local color="${purple}"; fi
  if [ "${1}" = "header" ]; then local color="${bold}""${tan}"; fi
  if [ "${1}" = "input" ]; then local color="${bold}"; printLog="false"; fi
  if [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then local color=""; fi
  # Don't use colors on pipes or non-recognized terminals
  if [[ "${TERM}" != "xterm"* ]] || [ -t 1 ]; then color=""; reset=""; fi

  # Print to $logFile
  if ${printLog}; then
    echo -e "$(date +"%m-%d-%Y %r") $(printf "[%9s]" "${1}") ${_message}" >> "${logFile}";
  fi

  # Print to console when script is not 'quiet'
  if ${quiet}; then
    return
  else
    echo -e "$(date +"%r") ${color}$(printf "[%9s]" "${1}") ${_message}${reset}";
  fi
}

function die ()       { local _message="${*} Exiting."; echo "$(_alert emergency)"; safeExit;}
function error ()     { local _message="${*}"; echo "$(_alert error)"; }
function warning ()   { local _message="${*}"; echo "$(_alert warning)"; }
function notice ()    { local _message="${*}"; echo "$(_alert notice)"; }
function info ()      { local _message="${*}"; echo "$(_alert info)"; }
function debug ()     { local _message="${*}"; echo "$(_alert debug)"; }
function success ()   { local _message="${*}"; echo "$(_alert success)"; }
function input()      { local _message="${*}"; echo -n "$(_alert input)"; }
function header()     { local _message="${*}"; echo "$(_alert header)"; }

# Log messages when verbose is set to "true"
verbose() { if ${verbose}; then debug "$@"; fi }

# Trap bad exits with your cleanup function
trap trapCleanup EXIT INT TERM

# Set IFS to preferred implementation
IFS=$' \n\t'

# Exit on error. Append '||true' when you run the script if you expect an error.
set -o errexit

# Run in debug mode, if set
if ${debug}; then set -x ; fi

# Exit on empty variable
if ${strict}; then set -o nounset ; fi

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`, for example.
set -o pipefail

# Run your script
mainScript

# Exit cleanly
safeExit
