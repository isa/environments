## Constants
NORMAL=`tput sgr0`
BLACK=`tput setaf 0`
BLUE=`tput setaf 4`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
MAGENTA=`tput setaf 5`

INFO="${GREEN}→${NORMAL}"
ERROR="${RED}→${NORMAL}"
PROGRESS="    ${BLACK}"

# Displays a colorful message
function message() {
   echo -e "$1${NORMAL}"
}

function download() {
   curl "$1" -o $HOME/Downloads/$2
}

function homebrew() {
   exists=`which brew`

   if [[ $exists != *brew ]]; then
      message "$PROGRESS Well, seems like you've already installed. ${GREEN}✔"
   else
      message "$PROGRESS installing.."
      ruby -e "`curl -fsSL https://raw.github.com/gist/323731`"
      message "$PROGRESS done. ${GREEN}✔"
   fi
}

function copy_app_from_image() {
   yes | hdiutil attach app.dmg -mountpoint /Volumes/app > /dev/null
   app=`find /Volumes/app -name *.app -prune 2>/dev/null | head -1`
   cp -R "$app" /Applications/
   hdiutil detach /Volumes/app > /dev/null
}

# installing required app
# if it is homebrew, it's a special installation
# if it is pipe delimited, then each parameter has to be brew-package-name;executable-name-after-installation format
# if it is dmg, then it is plain copy
# sorry for the long method, but bash has limited function capabilities
function require() {
   if [[ $1 == "homebrew" ]]; then
      homebrew
   elif [[ $2 == *dmg ]]; then
      message "$INFO Installing ${MAGENTA}$1"
      mkdir -p $HOME/.temp && cd $HOME/.temp

      message "$PROGRESS downloading.."
      curl --silent "$2" -o app.dmg

      message "$PROGRESS installing.."
      copy_app_from_image

      rm -rf $HOME/.temp
      message "$PROGRESS done. ${GREEN}✔"
   elif [[ $2 == *zip ]]; then
      message "$INFO Installing ${MAGENTA}$1"
      mkdir -p $HOME/.temp && cd $HOME/.temp

      message "$PROGRESS downloading.."
      curl --silent "$2" -o app.zip

      message "$PROGRESS installing.."
      unzip app.zip > /dev/null
      app=`find . -name *.app -prune 2>/dev/null`

      if [[ $app == *app ]]; then
         cp -R "$app" /Applications/
      else
         mv *.dmg app.dmg
         copy_app_from_image
      fi

      message "$PROGRESS done. ${GREEN}✔"
      rm -rf $HOME/.temp
   else
      IFS="|"
      formulas="$1"
      for formula in $formulas; do
         package=`echo $formula | cut -d";" -f1`
         command=`echo $formula | cut -d";" -f2`

         message "$INFO Installing ${MAGENTA}$package"
         exists=`which $command`

         if [[ $exists == *$command ]]; then
            message "$PROGRESS Well, seems like you've already installed. ${GREEN}✔"
         else
            brew install $package > /dev/null
         fi
      done
   fi
}

function configure_vim() {
   git clone http://github.com/isa/vim-vironment $HOME/.vim-vironment > /dev/null
   cd $HOME/.vim-vironment
   git submodule init > /dev/null
   git submodule update > /dev/null
   cd $HOME
}

function link_user_folder() {
   rm -rf $HOME/.profile

   ln -s $HOME/.environments/osx/.profile $HOME/.profile
   ln -s $HOME/.environments/osx/.ssh $HOME/.ssh
   ln -s $HOME/.environments/.gitconfig $HOME/.gitconfig
   ln -s $HOME/.environments/.gitignore $HOME/.gitignore
   ln -s $HOME/.environments/.hgrc $HOME/.hgrc

   ln -s $HOME/.vim-vironment/vim $HOME/.vim
   ln -s $HOME/.vim-vironment/vimrc $HOME/.vimrc
}

function setup_dock() {
   # dock
   defaults write com.apple.dock mineffect suck
   # these are for macbook air, change if you need it
   defaults write com.apple.dock tilesize -int 42
   defaults write com.apple.dock magnification -bool true
   defaults write com.apple.dock largesize -int 56

   # enable iTunes notifications
   defaults write com.apple.dock itunes-notifications -bool TRUE


}

function setup_system() {
   # show IP address in the login screen
   defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo IPAddress

   # change background
   # login window
   curl -s "http://ns223506.ovh.net/rozne/16fddb6222d841e447f89002e4554593/wallpaper-444284.jpg" -o $HOME/Pictures/login.jpg
   defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture "$HOME/Pictures/login.jpg"
   # desktop
   curl -s "http://ns223506.ovh.net/rozne/b47a59331f4f1ba89c13d494cdefe08e/wallpaper-314929.jpg" -o $HOME/Pictures/desktop.jpg
   defaults write com.apple.desktop Background '{default = {ImageFilePath = "~/Pictures/desktop.jpg"; };}'

   # fix iTunes zoom button
   defaults write com.apple.iTunes full-window 1

   setup_dock

   # require password when waking from sleep
   defaults -currentHost write com.apple.screensaver askForPassword -int 0

   # disable re-opening apps on logon
   defaults write com.apple.loginwindow TALLogoutSavesState -bool false

   # revert back to real "natural scrolling"
   defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

   # enable keyboard access for all controls
   defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

   # enable subpixel font rendering on non-Apple LCDs
   defaults write NSGlobalDomain AppleFontSmoothing -int 2

   # show all file extensions
   defaults write NSGlobalDomain AppleShowAllExtensions -bool true
   
   # speed up the keyboard
   defaults write NSGlobalDomain InitialKeyRepeat -int 4
   defaults write NSGlobalDomain KeyRepeat -int 0.02
}

function setup_user() {
   configure_vim
   link_user_folder
}
