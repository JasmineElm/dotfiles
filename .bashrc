# shellcheck shell=bash
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

#ignore  C^S C^Q (suspend, resume commands)
stty -ixon

shopt -s checkwinsize
shopt -s globstar
# HISTORY

_HIST_DIR="$HOME/.bash_history/"
[[ ! -d "$_HIST_DIR" ]] && mkdir -p "$_HIST_DIR"
HISTFILE="$_HIST_DIR"history-$(date +%Y%m%d-%H%M%S)
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%d-%m-%y %H:%M  "
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

h() {
  grep -v "^#.*$" "$_HIST_DIR"* | cut -d: -f2- | grep -i "$*"
}

#hist() {
#  grep -vh "^#.*$" "$_HIST_DIR"*
#}


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# and the color bit...
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  color_prompt=yes
else
  # shellcheck disable=SC2034
  color_prompt=''
fi

# sources /etc/bash.bashrc).
# shellcheck disable=SC1091
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## case insensitive completion?
# echo  "set completion-ignore-case" >> /etc/inputrc

# local shell functions and aliases
# shellcheck disable=SC1090
[[ ! -f ~/.shell_functions ]] || . ~/.shell_functions
# shellcheck disable=SC1090
[[ ! -f ~/.aliases ]] || . ~/.aliases
# shellcheck disable=SC1090
[[ ! -f ~/.secret_aliases ]] || . ~/.secret_aliases

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH:~/.local/bin"

###################################################
# just display $BASEDIR..
PS1="\\W > "
# a continuation should look like one...
PS2="⋯ "


# vi wherever possible please
set -o vi
VIMPATH=$(command -v vi)
export EDITOR=$VIMPATH
export MANPAGER="vim -M +MANPAGER -"
# but CTRL-L is useful too...
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# htop should use a dotfile for the sake of portability...
export HTOPRC="$HOME.htoprc"

PATH=$PATH:$HOME/.local/bin
