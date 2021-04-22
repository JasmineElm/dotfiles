# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# HISTORY
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%d-%m-%y %H:%M  "
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## case insensitive completion?  Echo this to /etc/inputrc
#  set completion-ignore-case on

# local shell functions and aliases
[[ ! -f ~/.shell_functions ]] || . ~/.shell_functions
[[ ! -f ~/.aliases ]] || . ~/.aliases
[[ ! -f ~/.secret_aliases ]] || . ~/.secret_aliases

## Directories

bind '"\e[A": history-search-backward'
bind '"\eOA": history-search-backward'

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH:~/.local/bin"






###################################################

function git_color {
  local git_status
  git_status="$(git status 2> /dev/null)"
  if [[ ${git_status} =~ "Changes to be committed" ]] || [[
 ${git_status} =~ "Changes not staged" ]]; then
    c="01;33m"
  elif [[ ${git_status} =~ "working tree clean" ]]; then
    c="01;32m"  
  elif [[ ${git_status} =~ "but untracked files present" ]];
then
    c="01;33m"  
  else 
    c="01;39m"
    icon="❯"
  fi
  echo -e "$c"
}

color=$(git_color)
# just display $BASEDIR..
PS1="\W ▶ "
# PS1="\e[\$(git_color)[\u@\h \W]\$ \e[m "
# PS1="\[\e[\$(git_color) \W \]\e[m"
# PS1="\[\e[01;39m\W \]"
#coloured chevron if we're in a git repo...
# PS1+="\[\e[\$(git_color)\]\[\e[0m\]"

export MANPAGER="vim -M +MANPAGER -"
eval "$(pandoc --bash-completion)"
