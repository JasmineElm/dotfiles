#!/bin/bash
#
#Backs up the most important dots if they've changed.
                                                                  
USAGE="Back up select dot files. The 'g' flag pushes to git\nusage: $0 [g]" 
BACKUP_DIR=$HOME'/Dropbox/dots/'
GIT_DIR=$HOME'/Dropbox/git/dotfiles'
SCRIPT=$0


timestamp() {
  date +"%d-%m-%Y @ %T"
}

backup() {
  cd $HOME
  for dot in .aliases .bashrc .inputrc .nanorc .profile $SCRIPT .secret_aliases .shell_functions .tmux.conf .vimrc .vim/local_functions.vim .zshrc; do
    rsync $HOME_DIR$dot $COPY_DIR;
  done
}

git_commit() {
  if [[ `git status --porcelain` ]]; then
      git add .
      git commit -m "Update: $(timestamp)"
      git push
  fi
}
#---------------------------------------------------#
if [ -z $1 ]; then
  COPY_DIR=$BACKUP_DIR
  backup
  elif [ -n $1 ]
then
  case $1 in
    "g")
      COPY_DIR=$GIT_DIR
      backup
      cd $GIT_DIR
      git_commit
      ;;
   *)
     printf $USAGE
     ;;
 esac
fi

ls -haltr $COPY_DIR'/'
