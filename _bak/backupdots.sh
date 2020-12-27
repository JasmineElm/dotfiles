#!/bin/bash
#
#Backs up the most important dots if they've changed.
                                                                  
#BACKUP_DIR=$HOME'/Dropbox/dots/'
GIT_DIR=$HOME'/Dropbox/git/dotfiles'
SCRIPT=$(realpath $0)
BACKUP_SERVICE='dropbox'
DOT_DIR='dots'
RESTORE_DIR=$HOME'/'$DOT_DIR # best not to blindly restore to $HOME...

USAGE="Back up select dot files. \n\t+ 'g' flag pushes to git\n\t+ 'r' flag restores to $RESTORE_DIR\n\t+ no argument, copies dots to $BACKUP_SERVICE\nusage: $0 [g|r]" 

#---------------------------------------------------#

timestamp() {
  date +"%d-%m-%Y @ %T"
}

backup() {
  cd $HOME
  for dot in .aliases .bashrc .inputrc .nanorc .profile $SCRIPT .secret_aliases .shell_functions .tmux.conf .vimrc .vim/local_functions.vim .zshrc; do
    echo rclone copy $HOME_DIR$dot $BACKUP_SERVICE:$DOT_DIR
    rclone copy $HOME_DIR$dot $BACKUP_SERVICE:$DOT_DIR
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
  echo "restoring dotfiles to "$RESTORE_DIR
  rm -rf $RESTORE_DIR/*
  rclone copy $BACKUP_SERVICE:$DOT_DIR  $RESTORE_DIR
}

#---------------------------------------------------#

if [ -z $1 ]; then
  COPY_DIR=$BACKUP_DIR
  backup
  elif [ -n $1 ]
then
  case $1 in
    "g") #git
      # backup > restore > git
      backup
      restore
      cp $RESTORE_DIR/* $GIT_DIR
      git_commit
      ;;
    "r") #restore
      restore      
      ;;
    *)
     echo -e $USAGE
     ;;
 esac
fi
