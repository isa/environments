#!/usr/bin/env bash

OS=`uname`

if [[ $OS -eq "Darwin" ]]; then
   source $HOME/.environments/osx/boot.sh
else
   source $HOME/.environments/linux/boot.sh
fi
