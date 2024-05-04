### POWERLEVEL 10K STARTS:
#
 if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f  ~/powerlevel10k/powerlevel10k.zsh-theme ]] || source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#
### POWERLEVEL 10K ENDS

## Local functions / aliases
[[ ! -f ~/.shell_functions ]] || source ~/.shell_functions
[[ ! -f ~/.aliases ]] || source ~/.aliases
[[ ! -f ~/.secret_aliases ]] || source ~/.secret_aliases


# Case insensitive completion (lower > * _ONLY_)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

GEM_HOME="$HOME/gems"

# Path needs to have GEM_HOME close to the beginning...
PATH=$HOME/gems/bin:$PATH:/snap/bin:$HOME/Scripts:$PATH:$HOME/.local/bin

# add date to `history`
export HISTTIMEFORMAT="%m/%d - %H:%M:%S: "

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
source ~/powerlevel10k/powerlevel10k.zsh-theme
