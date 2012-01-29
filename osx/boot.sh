#!/usr/bin/env bash

source $HOME/.environments/osx/functions.sh

message "$INFO Booting system for the first time for ${BLUE}OSX"
message "$INFO First things first, we need to install ${MAGENTA}HomeBrew"

# require "homebrew"
# brew update

# package installations
# require "git;git|ack;ack|rlwrap;rlwrap|unrar;unrar"
# require "virtualhost.sh;virtualhost.sh|macvim;mvim"
# require "python3;python3|groovy;groovy|mercurial;hg"

# setup_user

# install mac apps
require "Google Chrome" "https://dl.google.com/chrome/mac/stable/CHFA/googlechrome.dmg"
