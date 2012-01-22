BLACK="\[\e[0;30m\]"
DGRAY="\[\e[1;30m\]"
BLUE="\[\e[0;34m\]"
LBLUE="\[\e[1;34m\]"
GREEN="\[\e[0;32m\]"
LGREEN="\[\e[1;32m\]"
CYAN="\[\e[0;36m\]"
LCYAN="\[\e[1;36m\]"
RED="\[\e[0;31m\]"
LRED="\[\e[1;31m\]"
PURPLE="\[\e[0;35m\]"
LPURPLE="\[\e[1;35m\]"
BROWN="\[\e[0;33m\]"
YELLOW="\[\e[1;33m\]"
LGRAY="\[\e[0;37m\]"
WHITE="\[\e[1;37m\]"
RESET_COLOR="\[\e[0m\]"

if [[ -n "$PS1" ]]; then
  export PS1="$BLUE\\u$WHITE in $DGRAY\\w\\n${GREEN}λ ${RESET_COLOR}"
  export SUDO_PS1="$BLUE\\u$WHITE in $DGRAY\\w\\n${RED}λ ${RESET_COLOR}"
fi

alias ls='ls -G'
alias ll='ls -alh'
alias mkdir='mkdir -p'
alias cp='cp -R'
alias chown='chown -R'
alias chmod='chmod -R'
alias pp='cd ~/Projects'
alias grep='grep -r --color'
alias vm='VBoxManage'
alias rspec='rspec --color --format documentation'
alias pnc='pn `pwd`'
alias clj='rlwrap clj'
alias g='mvim --remote-tab-silent'
alias df='df -h'
alias du='du -sh'
alias fansh='rlwrap fansh'
alias import=python_import

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
export PATH=$HOME/.environments/osx/bin:/usr/local/sbin:/usr/local/bin:/usr/local/mysql/bin:$JAVA_HOME/bin:$PATH
export EDITOR="mvim -f"
export ANDROID_HOME=/usr/local/Cellar/android-sdk/r14
export ECHO_NEST_API_KEY="TA4OHCAV5FQCJTWVJ"

function uservm() {
   . "$HOME/.rvm/scripts/rvm"
}

function python_import() {
   python -ic "import $1"
}

function svnst() {
   svn st | ack --match '^[ADM\?]'
}

function pn() {
    open "peepopen://$1?editor=MacVim"
}
