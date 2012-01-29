#!/usr/bin/env bash

source $HOME/.environments/osx/functions.sh

message "$INFO Booting system for the first time for ${BLUE}OSX"
message "$INFO First things first, we need to install ${MAGENTA}HomeBrew"

require "homebrew"
brew update

# package installations
require "git;git|ack;ack|rlwrap;rlwrap|unrar;unrar"
require "virtualhost.sh;virtualhost.sh|macvim;mvim"
require "python3;python3|groovy;groovy|mercurial;hg"
require "fantom;fansh|tree;tree|wget;wget"

# install mac apps
require "Google Chrome" "https://dl.google.com/chrome/mac/stable/CHFA/googlechrome.dmg"
require "LaunchBar" "http://www.obdev.at/downloads/launchbar/LaunchBar-5.1.3.dmg"
require "Speed Download Lite" "http://mirror.nscocoa.com/~yazsoftc1/files/sdl/sdl.zip"
require "iTerm2" "http://iterm2.googlecode.com/files/iTerm2-1_0_0_20120123.zip"

# and finally
setup_user


# don't forget
# apply iTerm settings
# download pckeyboardhack, keyremap4macbook

# keyboard speed
# tap to click
# touchpad speed
# desktop background
# desktop icon size
# dock magnification, dock size, minimize to app
