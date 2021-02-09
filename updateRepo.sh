#!/usr/bin/env bash


######  VARIABLES    ###########################################

_dot=dotfiles/
_vim=$_dot/.vim/
_vit=$_vim/templates
_nwm=$_dot.newsboat
_nwp=$_nwm/plugin/
_repo="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
######  FUNCTIONS    ###########################################

cd "$_repo"

_create() {
  mkdir -p $_dot
  mkdir -p $_vit
  mkdir -p $_nwp
}

_update() {
  for dot in ".aliases" ".bashrc" ".gitconfig" ".inputrc" ".nanorc" ".profile" ".shell_functions" ".tmux.conf" ".vimrc" ".zshrc" ; do
    cp "$HOME"/"$dot" $_dot     
    done     

  ## vim
  cp "$HOME"/.vim/local_functions.vim $_vim
  cp "$HOME"/.vim/templates/*.skeleton $_vit 

  # newsboat
  cp "$HOME"/.newsboat/plugin/*.sh $_nwp
  cp "$HOME"/.newsboat/urls $_nwm

  git add .
}

######  MAIN         ###########################################  

_main() {
  _create
  _update
}

_main 

