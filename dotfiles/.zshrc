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

# Case insensitive completion (lower > * _ONLY_)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

GEM_HOME="$HOME/gems"

# Path needs to have GEM_HOME close to the beginning...
PATH=$HOME/gems/bin:$PATH:/snap/bin:$HOME/Scripts:$PATH:$HOME/.local/bin


BROWSER="firefox"
EDITOR="vi"

# add date to `history`
export HISTTIMEFORMAT="%m/%d - %H:%M:%S: "


GITHUB_USERNAME=JasmineElm


# Directories
#
export STUDY_DIR=$HOME/Dropbox/msc_computing
export DRPBX_DIR=$HOME'/Dropbox/'
export SCRPT_DIR=$HOME'/Scripts/'
export REPO_DIR=$DRPBX_DIR'/git/'
export BLOG_DIR=$GIT_DIR'/JasmineElm.github.io/_posts/'

