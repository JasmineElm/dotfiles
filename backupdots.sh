#!/bin/bash

#Backs up the most important dots if they've changed.
#
# v0.0 - December 2020 - basic functionality

source $HOME/Scripts/rclone_env

#---------------------------------------------------#
script=$(realpath $0)

local_dot_dir=$HOME'/'$dots_dir
local_restore_dir=$HOME'/'$docs_dir'/'$dots_dir
local_repo_dir=$HOME'/'$repo_dir

usage="Back up select dot files. \n\t+ 'g' flag pushes to git\n\t+ 'r' flag restores to $local_restore_dir\n\t+ no argument, copies dots to $frst_cld\nusage: $0 [g|r]" 

dotfiles=(".aliases" ".bashrc" ".inputrc" ".mutt/muttrc" \
          ".nanorc" ".netrc" ".newsboat/urls" ".newsboat/plugin/send-to-pocket.sh" ".profile" "$script" \
          ".secret_aliases" ".shell_functions" ".tmux.conf" \
          ".vimrc" ".vim/local_functions.vim" ".vim/templates" ".wakatime.cfg" ".zshrc")
#---------------------------------------------------#

timestamp() { 
  date +"%d-%m-%Y @ %T" 
}
             
backup() {
  echo 'backing up dotfiles to '$frst_cld:$dots_dir
  log=$HOME$logs_dir/_$0_${FUNCNAME[0]}.log
  cd $HOME
  for dot in ${dotfiles[@]}; do
    echo rclone copy $dot $frst_cld:$dots_dir 
    rclone copy $dot $frst_cld:$dots_dir 
  done
}

git_commit() {
  echo ' committing to git...'
  if [[ `git status --porcelain` ]]; then
      git add .
      git commit -m "Update: $(timestamp)"
      git push
  fi
}

restore() {
  # we can manually restore after the fact...
  log=$logdir/_$0_${FUNCNAME[0]}.log
  mkdir -p $local_restore_dir
  rm -rf $local_restore_dir/*
  rclone copy $frst_cld:$dots_dir $local_restore_dir
}

prettify() {
  #prettify the repo rather than chuck everything in a flat dir...
  cd $local_repo_dir'/'$dots_dir
  pwd
  mv $dots_dir'/backupdots.sh' .
  mkdir -p $dots_dir'/.vim'
  mkdir -p $dots_dir'/.newsboat/plugin'
  mv $dots_dir'/local_functions.vim' $dots_dir'/.vim/local_functions.vim'
  mv $dots_dir'/urls' $dots_dir'/.newsboat/'
  mv $dots_dir'/send-to-pocket.sh' $dots_dir'/.newsboat/plugin/'
  for i in 'muttrc' '.netrc' '.secret_aliases' '*waka*' '*.swp'; do
    find -iname $i -delete
  done
  tree -a -I '.git'
}

#---------------------------------------------------#

if [ -z $1 ]; then
  backup
elif [ -n $1 ]; then
  case $1 in
    "g") #git
      # backup > restore > git
      backup
      restore
      rsync -r $local_restore_dir $local_repo_dir'/'$dots_dir
      prettify
      git_commit
      ;;
    "r") #restore
      restore      
      ;;
    *)
     echo -e $usage
     ;;
 esac
fi
