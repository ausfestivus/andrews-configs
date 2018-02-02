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
  echo -n "Creating $olddir for backup of any existing dotfiles in ~"
  mkdir -p $olddir
  echo "...done"
  
  # change to the dotfiles directory
  echo -n "Changing to the $dir directory"
  cd $dir || exit
  echo "...done"
  
  # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
  for file in $files; do
    echo "Working on $file"
    if [ $file == "_awsAliases" ]; then # if were installing the _awsAliases file
      # check that AWS CLI is installed and a credentials file exists skip to next if not.
      #TODO # AWS CLI check goes here
      #  Credentials are in place check goes here.
      # we check if the env var for the creds file is set OR the file exists
      echo -n "Working on $file and determining if AWS credentials are defined"
      if [ -z credentialFileLocation==${AWS_SHARED_CREDENTIALS_FILE} ] || [ -f ~/.aws/credentials ]; then
        # if one is true we want to put the file in place
        echo "... they are."
        echo -n "Moving existing .$file from ~ to $olddir"
        mv ~/.$file $olddir
        echo "...done"
        echo -n "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
        echo "...done"
      else
        echo "... they arent."
        break # exit this pass of the loop
        # if one is false then we dont want to drop in our _awsAliases
      fi
    fi
    echo -n "Moving existing .$file from ~ to $olddir"
    mv ~/.$file $olddir
    echo "...done"
    echo -n "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
    echo "...done"
  done
}

# first up, which OS are we on?
if [ $OSTYPE == "darwin16" ] || [ $OSTYPE = "darwin17" ]; then
  # macOS specific commands go here
  files=$Macfiles
  echo "Hi, im a Mac and my name is '$HOSTNAME'"
  domagic #snap our dotfiles into place
  elif [ $OSTYPE == "linux-gnu" ]; then
  # Linux specifc commands go here
  files=$Linuxfiles
  echo "Hi, im a Linux machine and my name is '$HOSTNAME'"
  domagic #snap our dotfiles into place
else
  echo "Couldnt work out what OS we're running on."
fi
