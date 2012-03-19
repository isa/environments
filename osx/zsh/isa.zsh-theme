function prompt_char {
  git branch >/dev/null 2>/dev/null && echo '±' && return
  hg root >/dev/null 2>/dev/null && echo '☿' && return
  echo "λ"
}

autoload -U colors && colors
setopt prompt_subst
#PROMPT='%{$fg[magenta]%}$(lambda)%{$reset_color%} %~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}'
PROMPT='%{$fg[blue]%}%n%{$fg[white]%} in %{$fg[grey]%}${PWD/#$HOME/~}
%(!.%{$fg[green]%}.%{$fg[red]%})$(prompt_char) %{$reset_color%}'

autoload -U add-zsh-hook

