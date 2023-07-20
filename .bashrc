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


PS1='\[\033[01;34m\][\h] \W \[\033[00m\]'
if [[ -f /etc/bash_completion.d/git-prompt ]]; then
  source /etc/bash_completion.d/git-prompt
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWCOLORHINTS=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWUPSTREAM="auto"
  export GIT_PS1_DESCRIBE_STYLE="branch"
PS1="$PS1$(__git_ps1 "[%s]")"
fi

## COMPLETION

## case insensitive completion?
[[ -f /usr/share/bash-completion/completions/git ]] \
  && source /usr/share/bash-completion/completions/git

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
## WAKATIME
# shellcheck disable=SC1090
pre_prompt_command() {
    version="1.0.0"
    entity=$(echo $(fc -ln -0) | cut -d ' ' -f1)
    [ -z "$entity" ] && return # $entity is empty or only whitespace
    $(git rev-parse --is-inside-work-tree 2> /dev/null) \
      && local project="$(basename $(git rev-parse --show-toplevel))" \
      || local project="Terminal"
    (~/.wakatime/wakatime-cli --write --plugin "bash-wakatime/$version" \
      --entity-type app --project "$project" \
      --entity "$entity" 2>&1 > /dev/null &)
}
[[ -f ~/.wakatime.cfg ]] && \
  PROMPT_COMMAND="pre_prompt_command; $PROMPT_COMMAND"
