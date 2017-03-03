#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables
dir=~/andrews-configs/dotfiles     # dotfiles directory
olddir=~/andrews-configs/dotfiles_old # old dotfiles backup directory
# Add the dotfile name to the following items depending on which OS you want it in.
# eg profile isnt relevant to macOS.
Linuxfiles="vimrc"    # list of files/folders to symlink in homedir
Macfiles="vimrc"

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
else
  echo "Couldnt work out what we're on."
fi
