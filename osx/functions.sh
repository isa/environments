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
      message "$PROGRESS installing {"
      ruby -e "`curl -fsSL https://raw.github.com/gist/323731`"
      message "$PROGRESS }"
   fi
}

# installing required app
# if it is homebrew, it's a special installation
# if it is pipe delimited, then each parameter has to be brew-package-name;executable-name-after-installation format
# if it is dmg, then it is plain copy
function require() {
   if [[ $1 == "homebrew" ]]; then
      homebrew
   elif [[ $2 == *dmg ]]; then
      message "$INFO Installing ${MAGENTA}$1"
      mkdir -p $HOME/.temp && cd $HOME/.temp

      message "$PROGRESS downloading.."
      curl --silent "$2" -o app.dmg

      message "$PROGRESS installing.."
      hdiutil attach app.dmg -mountpoint /Volumes/app > /dev/null
      cp -R "`find /Volumes/app -name *.app -prune`" /Applications/
      hdiutil detach /Volumes/app > /dev/null
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
