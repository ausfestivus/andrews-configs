#!/bin/bash
############################
# detectOS.sh
# This script detects which OS were running in.
############################

if [[ "$OSTYPE" =~ ^darwin ]]; then # macOS specific commands go here
  echo "Hi, im a Mac and my name is '$HOSTNAME'"
elif [ $OSTYPE == "linux-gnu" ]; then # Linux specific commands go here
  echo "Hi, im a Linux machine and my name is '$HOSTNAME'"
fi
