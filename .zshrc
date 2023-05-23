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


if [ -e /home/x220/.nix-profile/etc/profile.d/nix.sh ]; then . /home/x220/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/james/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

