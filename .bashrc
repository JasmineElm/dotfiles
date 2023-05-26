# shellcheck shell=bash
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

#ignore  C^S C^Q (suspend, resume commands)
stty -ixon

# HISTORY
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%d-%m-%y %H:%M  "
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

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
# source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
# source $(brew --prefix)/opt/chruby/share/chruby/auto.sh

PATH=$PATH:$HOME/.local/bin
PATH="/opt/homebrew/bin:/opt/homebrew/opt/gnu-getopt/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/findutils/share/man:$MANPATH"



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/james/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/james/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/james/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/james/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
