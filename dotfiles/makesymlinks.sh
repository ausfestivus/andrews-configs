#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables
dir=~/andrews-configs/dotfiles     # dotfiles directory
olddir=~/andrews-configs/dotfiles_old # old dotfiles backup directory
# Add the dotfile name to the following items depending on which OS you want it in.
# eg profile isnt relevant to macOS.
Linuxfiles="vimrc bash_profile bashrc _awsAliases"    # list of files/folders to symlink in homedir
Macfiles="vimrc bash_profile bashrc _awsAliases"

domagic ()
{
  ##########
  # create dotfiles_old in homedir
  echo "Creating $olddir for backup of any existing dotfiles in ~"
  mkdir -p $olddir
  echo "...done"

  # change to the dotfiles directory
  echo "Changing to the $dir directory"
  cd $dir
  echo "...done"

  # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
  for file in $files; do
    if [$file == "_awsAliases"]; then # if were installing the _awsAliases file
      # check that AWS CLI is installed and a credentials file exists skip to next if not.
      #TODO # AWS CLI check goes here
      #  Credentials are in place check goes here.
      # we check if the env var for the creds file is set OR the file exists
      echo "Working on $file and determining if AWS credentials are defined"
      if [ -z credentialFileLocation=${AWS_SHARED_CREDENTIALS_FILE} ] || [ -f ~/.aws/credentials ]; then
        # if one is true we want to put the file in place
        echo "... they are."
        echo "Moving existing .$file from ~ to $olddir"
        mv ~/.$file $olddir
        echo "...done"
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
        echo "...done"
      else
        echo "... they arent."
        break # exit this pass of the loop
        # if one is false then we dont want to drop in our _awsAliases
      fi


    fi
    echo "Moving existing .$file from ~ to $olddir"
    mv ~/.$file $olddir
    echo "...done"
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
    echo "...done"
  done
}

# first up, which OS are we on?
if [ $OSTYPE == "darwin16" ]; then
  # macOS specific commands go here
  files=$Macfiles
  echo "Hi, im a Mac and my name is '$HOSTNAME'"
  domagic
elif [ $OSTYPE == "linux-gnu" ]; then
  # Linux specifc commands go here
  files=$Linuxfiles
  echo "Hi, im a Linux machine and my name is '$HOSTNAME'"
  domagic
else
  echo "Couldnt work out what we're on."
fi
