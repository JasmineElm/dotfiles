#!/usr/bin/env bash

###  DEBUG          ###########################################################
# set -u -e -o errtrace -o pipefail
#trap "echo ""errexit: line $LINENO. Exit code: $?"" >&2" ERR
IFS=$'\n\t'

###  VARIABLES      ###########################################################
_MAIN_ONLY=0        ## set to 1 if you dont want a branch for each OS
_THIS_SCRIPT=$(basename "$0")
_COMMON_FILES=("$_THIS_SCRIPT" README.md) ## files to sync to all branches

## Colours
_bld=$(tput bold)
_nrm=$(tput sgr0)

###  FUNCTIONS      ###########################################################

is_main_only() {
  # check if we're running in main only mode
  [[ $_MAIN_ONLY -eq 1 ]]
}


print_help() {
  cat <<HEREDOC

Update dotfiles repo by copying relevant files from \$HOME.
To manually add files, manually copy them to the repo
ensuring that their repo path matches the relative path  from \$HOME
  e.g., '\$HOME/.vim/vimrc' should be copied to '.vim/vimrc' in the repo.

By default, this script will create a branch for each OS
and push changes to that branch.
If you want to run this script without creating a branch,
use the $_bld"_IS_MAIN_ONLY"$_nrm variable.


Usage:
  $_THIS_SCRIPT [<arguments>]

Options:
  $_bld-h$_nrm    Show this screen.
  $_bld-l$_nrm    update local repo from \$HOME
  $_bld-r$_nrm    update remote repo after updating local repo
  $_bld-i$_nrm    install dotfiles from repo to \$HOME

HEREDOC
}

### FUNCTIONS      ############################################################

datestamp() {
  # add a datestamp to the commit message
  date +"%Y-%m-%d %H:%M"
}

test_rsync() {
  # we need rsync for this to work...
  [[ -x $(which rsync) ]] || \
    sudo apt install rsync -y
}

list_files() {
  # list all files that aren't .git* or in $_COMMON_FILES
  filelist=$(find . -type f -not -path "./.git*" | sed 's/^\.\///')
  for f in "${_COMMON_FILES[@]}"; do
    filelist=$(echo "$filelist" | grep -v "$f")
  done
  echo "$filelist"
}

clean() {
  # Remove empty, swap and temp files
  find . -type f \( -iname "*.swp" \
                  -o -iname "*~" \
                  -o -iname "*.tmp" \) -delete
  find . -empty -delete
}

delete_if_not_exists() {
  # delete a file if it doesn't also exist in the path
  local f="$1"
  local path="$2"
  [[ ! -f $path$f ]] && rm "$f"
}

update_local() {
  # use rsync to copy files from $HOME to this repo
  # Add new files to the _repo_ and this'll sync them
  # remove files from  $HOME and this'll delete them
  for f in $(list_files); do
    rsync -a "$HOME/$f" "$f" 2>/dev/null || true
    delete_if_not_exists "$f" "$HOME/"
  done
  clean
}

determine_branch() {
  unm=$(uname -a)
  if [[ $unm == *"Microsoft"* ]]; then
    branch="wsl"
  elif [[ $unm == *"Darwin"* ]]; then
    branch="macos"
  elif [[ $unm == *"Android"* ]]; then
    branch="android"
  elif [[ $unm == *"Linux"* ]]; then
    branch="linux"
  else
    branch="unknown" && exit 1
  fi
  echo "$branch"
}

## Branch management
select_branch() {
  local branch
  if [[ $(is_main_only) -eq 1 ]]; then
    branch="main"
  else
    branch=$(determine_branch)
  fi
  echo "$branch"
}

list_remote_branches() {
  # list all remote branches
  git ls-remote --heads origin | cut -c 53-
}

branch_exists() {
  # check if branch exists
  local branch="$1"
  git rev-parse --verify "$branch" >/dev/null 2>&1 | wc -l
}

sync_branches() {
  # copy a file to all branches
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  for branch in $(list_remote_branches); do
    git checkout "$branch" && git pull
    for file in "${_COMMON_FILES[@]}"; do
      echo "Copying $file to $branch"
      git checkout "$current_branch" -- "$file"
      git add "$file"
    done
    git commit -q -m "sync: $(datestamp)" && git push -u origin "$branch"
  done
  git checkout "$current_branch"
}

switch_branch() {
  if [[ $(is_main_only) -eq 1 ]]; then
    git checkout main
    return
  else
    if [[ -z "$branch" ]]; then
      echo "No branch specified"
      exit 1
    elif [[ $(branch_exists "$branch") -eq 0 ]]; then
      git checkout "$branch"
    else
      git checkout -b "$branch"
    fi
  fi
}

pushit() {
  git pull && git add .
  git commit -q -m "sync: $(datestamp)"
  git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
}

update_remote() {
  # update, and push any changes
  branch=$(select_branch)
  switch_branch "$branch"
  update_local
  out_of_sync=$(git status --porcelain | wc -l)
  [ "$out_of_sync" -eq 0 ] || pushit
}


install(){
  # install the dotfiles
  git pull && git checkout "$(select_branch)"
  files=$(list_files)
  backup_dir="$HOME/.dotfiles_backup"
  test_rsync ## ensure rsync is installed
  echo "backing up existing files"
  for file in $files; do
    mkdir -p "$(dirname "$HOME/$file")"
    rsync -a "$HOME/$file" "$backup_dir/$file" 2>/dev/null || true
    rsync -a "$file" "$HOME/$file"
  done
}

_main() {
  if [[ -z "$*" ]]; then
    print_help
    exit 1
  fi
  while getopts ":lrhi" opt; do
    case $opt in
    l)
      update_local
      ;;
    r)
      update_remote
      sync_branches
      ;;
    i)
      install
      ;;
    h)
      print_help
      ;;
    *)
      echo "$_bld"ERROR: Invalid option: -"$OPTARG $_nrm"
      print_help
      exit 1
      ;;
    esac
  done
}

_main "$@"
