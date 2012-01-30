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
require "Dropbox" "http://cdn.dropbox.com/Dropbox%201.2.51.dmg"
require "Speed Download Lite" "http://mirror.nscocoa.com/~yazsoftc1/files/sdl/sdl.zip"
require "iTerm" "http://iterm2.googlecode.com/files/iTerm2-1_0_0_20120123.zip"

# and finally
setup_system
setup_user

# also download some necessary packages
download "http://pqrs.org/macosx/keyremap4macbook/files/PCKeyboardHack-7.2.0.pkg.zip" "PCKeyboardHack.zip"
download "http://pqrs.org/macosx/keyremap4macbook/files/KeyRemap4MacBook-7.5.0.pkg.zip" "KeyRemap4MacBook.zip"

message "$INFO Alrighty, it's all done and ready! ${GREEN}✔"
