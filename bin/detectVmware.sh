#!/bin/bash

# ioreg -l | grep -e "\"manufacturer\" = <\"VMware, Inc.\">"

#[[ ioreg -l | grep -e "\"manufacturer\" = <\"VMware, Inc.\">" ]] && isVMware=1
isVMware=""
isVMware=$(ioreg -l | grep -e "\"manufacturer\" \= <\"VMware, Inc.\">" 2>/dev/null)

if [[ $isVMware == *VMware* ]]; then
    echo "VMware Detected"
else
    echo "VMware NOT detected"
fi