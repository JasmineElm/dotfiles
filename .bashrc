# shellcheck shell=bash

[[ -f ~/.shell_functions ]] && source  ~/.shell_functions
[[ -f ~/.aliases ]] && source  ~/.aliases
[[ -f ~/.secret_aliases ]] && source  ~/.secret_aliases

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
# shellcheck disable=SC1091
# brew|apt  install bash-completion
[[ -f /usr/share/bash-completion/bash_completion ]] && \
  . /usr/share/bash-completion/bash_completion
[[ -f /etc/bash_completion ]] && \
  . /etc/bash_completion

#### PATH ####################################################################
# Install Ruby Gems to ~/gems
[[ -d ~/.local/bin ]] && PATH="$PATH:~/.local/bin"
[[ -d /opt/homebrew/bin ]] && PATH="$PATH:/opt/homebrew/bin"
[[ -d /opt/homebrew/opt/gnu-getopt/bin ]] && \
  PATH="$PATH:/opt/homebrew/opt/gnu-getopt/bin"
[[ -d /opt/homebrew/opt/coreutils/libexec/gnubin  ]] && \
  PATH="$PATH:/opt/homebrew/opt/coreutils/libexec/gnubin"
## GEMS
[[ -d ~/gems ]] &&  export GEM_HOME="~/gems"
[[ -d $GEM_HOME/bin ]] &&  PATH="$GEM_HOME/bin"

MANPATH="/usr/local/opt/findutils/share/man:$MANPATH"
VIMPATH=$(command -v vi)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###################################################
# just display $BASEDIR..
PS1="\\W > "
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
# source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
# source $(brew --prefix)/opt/chruby/share/chruby/auto.sh



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
