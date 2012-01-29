## Constants
NORMAL=`tput sgr0`
BLACK=`tput setaf 0`
BLUE=`tput setaf 4`
RED=`tput setaf 1`
GREEN=`tput setaf 2`

# Displays a colorful message
function message() {
   echo "$1"
}

function info() {
   message "${GREEN}→${NORMAL} $1${NORMAL}"
}

function error() {
   message "${RED}→${NORMAL} $1${NORMAL}"
}
