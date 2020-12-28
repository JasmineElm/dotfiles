#!/bin/bash
#
#Backs up the most important dots if they've changed.

source $HOME/Scripts/rclone_env                                                                   
script=$(realpath $0)

local_dot_dir=$HOME'/'$dots_dir
local_restore_dir=$HOME'/'$docs_dir'/'$dots_dir
local_repo_dir=$HOME'/'$repo_dir'/'$dots_dir

usage="Back up select dot files. \n\t+ 'g' flag pushes to git\n\t+ 'r' flag restores to $local_restore_dir\n\t+ no argument, copies dots to $frst_cld\nusage: $0 [g|r]" 

#---------------------------------------------------#

timestamp() { 
  date +"%d-%m-%Y @ %T" 
}

backup() {
  log=$logdir/_$0_${FUNCNAME[0]}.log
  cd $HOME
  for dot in .aliases .bashrc .inputrc .nanorc .profile $script .secret_aliases .shell_functions .tmux.conf .vimrc .vim/local_functions.vim .waka* .zshrc; do
    rclone copy $dot $frst_cld:$dots_dir 
  done
}

git_commit() {
  if [[ `git status --porcelain` ]]; then
      git add .
      git commit -m "Update: $(timestamp)"
      git push
  fi
}

restore() {
  # we can manually restore after the fact...
  log=$logdir/_$0_${FUNCNAME[0]}.log
  echo "restoring dotfiles to  "$local_restore_dir
  mkdir -p $local_restore_dir
  rm -rf $local_restore_dir/*
  rclone copy $frst_cld:$dots_dir $local_restore_dir
}

#---------------------------------------------------#

if [ -z $1 ]; then
  echo"!here"
  backup
elif [ -n $1 ]; then
  case $1 in
    "g") #git
      # backup > restore > git
      backup
      restore
      rsync -r $local_restore_dir $local_repo_dir
      cd $local_repo_dir
      pwd
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
