#!/bin/bash
############################
# detectOS.sh
# This script detects which OS were running in.
############################

if  [[ "$OSTYPE" =~ ^darwin ]]
# macOS specific commands go here
then
  echo "Hi, im a Mac and my name is '$HOSTNAME'"
elif [ $OSTYPE == "linux-gnu" ]
# Linux specific commands go here
then
  echo "Hi, im a Linux machine and my name is '$HOSTNAME'"
fi
