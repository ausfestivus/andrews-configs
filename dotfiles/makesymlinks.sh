#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables
dir=~/andrews-configs/dotfiles     # dotfiles directory
olddir=~/andrews-configs/dotfiles_old # old dotfiles backup directory
files="vimrc profile _awsAliases"    # list of files/folders to symlink in homedir

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
