# shellcheck shell=bash

[[ -f $HOME/.shell_functions ]] && source  "$HOME/.shell_functions"
[[ -f $HOME/.aliases ]] && source  "$HOME/.aliases"
[[ -f $HOME/.secret_aliases ]] && source  "$HOME/.secret_aliases"

stty -ixon

#### HISTORY #################################################################

_HIST_DIR="$HOME/.bash_history/"
_create_hist_dir
HISTFILE="$_HIST_DIR"history-$(date +%Y%m%d-%H%M%S)
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%d-%m-%y %H:%M  "
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

#### SHOPTS ##################################################################

shopt -s checkwinsize
shopt -s cdspell
shopt -s globstar
shopt -s nocaseglob
shopt -s autocd

#### PROMPT ##################################################################
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# and the color bit...
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  color_prompt=yes
else
  color_prompt=''
fi

#### COMPLETION ##############################################################
## case insensitive completion?
# echo  "set completion-ignore-case" >> /etc/inputrc

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
# brew|apt  install bash-completion
[[ -f /usr/share/bash-completion/bash_completion ]] && \
  . /usr/share/bash-completion/bash_completion
[[ -f /etc/bash_completion ]] && \
  . /etc/bash_completion

#### PATH ####################################################################
# Install Ruby Gems to ~/gems
[[ -d ~/.local/bin ]] && PATH="$PATH:$HOME/.local/bin"
# homebrew - test the dir before adding _all_ the paths...
[[ -d /opt/homebrew/ ]] && PATH="$PATH:/opt/homebrew/bin" && \
  [[ -d /opt/homebrew/opt/gnu-getopt/bin ]] && \
  PATH="$PATH:/opt/homebrew/opt/gnu-getopt/bin" && \
[[ -d /opt/homebrew/opt/coreutils/libexec/gnubin  ]] && \
  PATH="$PATH:/opt/homebrew/opt/coreutils/libexec/gnubin"
## GEMS
[[ -d $HOME/gems ]] &&  export GEM_HOME="$HOME/gems"
[[ -d $GEM_HOME/bin ]] &&  PATH="$PATH:$GEM_HOME/bin"

MANPATH="/usr/local/opt/findutils/share/man:$MANPATH"
VIMPATH=$(command -v vi)

[[ -d $HOME/.nvm ]] && export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###################################################
# just display $BASEDIR..
PS1="\\W \$ "
# a continuation should look like one...
PS2="⋯ "

# vi wherever possible please
set -o vi
export EDITOR=$VIMPATH
export MANPAGER="vim -M +MANPAGER -"
# but CTRL-L is useful too...
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# htop should use a dotfile for the sake of portability...
export HTOPRC="$HOME.htoprc"

##### WAKATIME, if installed  ###############################################
pre_prompt_command() {
    version="1.0.0"
    entity=$(echo $(fc -ln -0) | cut -d ' ' -f1)
    [ -z "$entity" ] && return # $entity is empty or only whitespace
    $(git rev-parse --is-inside-work-tree 2> /dev/null) && local project="$(basename $(git rev-parse --show-toplevel))" || local project="Terminal"
    (~/.wakatime/wakatime-cli --write --plugin "bash-wakatime/$version" --entity-type app --project "$project" --entity "$entity" 2>&1 > /dev/null &)
}

[[ -f ~/.wakatime/wakatime-cli ]] && PROMPT_COMMAND="pre_prompt_command; $PROMPT_COMMAND"
# >>> conda initialize >>>
