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

function setup_user() {
   configure_vim
   link_user_folder
}
