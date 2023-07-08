# shellcheck shell=bash
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

## SHORTCUTS
#ignore  C^S C^Q (suspend, resume commands)
stty -ixon
# but CTRL-L is useful too...
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
#bind -v

## SHOPTS
shopt -s checkwinsize
shopt -s cdspell
shopt -s globstar
shopt -s nocaseglob
shopt -s autocd

# HISTORY

_HIST_DIR="$HOME/.bash_history/"
[[ ! -d "$_HIST_DIR" ]] && mkdir -p "$_HIST_DIR"
HISTFILE="$_HIST_DIR"history-$(date +%Y%m)
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%d-%m-%y %H:%M  "
HISTCONTROL=ignoredups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

h() {
  grep -v "^#.*$" "$_HIST_DIR"* | cut -d: -f2- | grep -i "$*"
}

############################################

## PROMPT

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

# just display $BASEDIR..
PS1="\\W > "
# a continuation should look like one...
PS2="⋯ "

[[ -f /etc/bash_completion.d/git-prompt ]] && . /etc/bash_completion.d/git-prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true
PS1='\[\033[01;34m\]\W \[\033[00m\]$(__git_ps1 "[%s]") '

## COMPLETION

## case insensitive completion?
[[ -f /etc/bash_completion.d/git-completion ]] && . /etc/bash_completion.d/git-completion

# shellcheck disable=SC1091
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# local shell functions and aliases
# shellcheck disable=SC1090
[[ ! -f ~/.shell_functions ]] || . ~/.shell_functions
# shellcheck disable=SC1090
[[ ! -f ~/.aliases ]] || . ~/.aliases
# shellcheck disable=SC1090
[[ ! -f ~/.secret_aliases ]] || . ~/.secret_aliases

# vi wherever possible please
set -o vi
VIMPATH=$(command -v vim)
export EDITOR=$VIMPATH
export MANPAGER="vim -M +MANPAGER -"

# htop should use a dotfile for the sake of portability...
export HTOPRC="$HOME.htoprc"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/james/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/james/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/james/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/james/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
conda deactivate
# <<< conda initialize <<<
